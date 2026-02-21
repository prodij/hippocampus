#!/usr/bin/env node
const http = require('http');
const fs = require('fs');
const path = require('path');
const { execSync } = require('child_process');

const WORKSPACE = path.resolve(__dirname, '../..');
const PORT = 18999;

const LIMITS = {
  'HIPPOCAMPUS.md': 2048,
  'MEMORY.md': 4096,
};
const TOTAL_WARN = 30000;

function json(res, data, status = 200) {
  res.writeHead(status, { 'Content-Type': 'application/json' });
  res.end(JSON.stringify(data));
}

function listFiles(dir, prefix = '') {
  let results = [];
  for (const f of fs.readdirSync(dir, { withFileTypes: true })) {
    const rel = prefix ? `${prefix}/${f.name}` : f.name;
    if (f.name.startsWith('.') || f.name === 'node_modules') continue;
    if (f.isDirectory()) {
      results = results.concat(listFiles(path.join(dir, f.name), rel));
    } else if (f.name.endsWith('.md')) {
      const stat = fs.statSync(path.join(dir, f.name));
      results.push({ path: rel, size: stat.size, modified: stat.mtime.toISOString() });
    }
  }
  return results;
}

function gitLog(filePath, limit = 20) {
  try {
    const out = execSync(
      `git log --follow --format="%H||%ai||%s" -${limit} -- "${filePath}"`,
      { cwd: WORKSPACE, encoding: 'utf-8', timeout: 5000 }
    );
    return out.trim().split('\n').filter(Boolean).map(line => {
      const [hash, date, ...msg] = line.split('||');
      return { hash, date, message: msg.join('||') };
    });
  } catch { return []; }
}

function gitDiff(hash, filePath) {
  try {
    return execSync(
      `git diff ${hash}~1..${hash} -- "${filePath}"`,
      { cwd: WORKSPACE, encoding: 'utf-8', timeout: 5000 }
    );
  } catch { return '(no diff available)'; }
}

function gitShow(hash, filePath) {
  try {
    return execSync(
      `git show ${hash}:"${filePath}"`,
      { cwd: WORKSPACE, encoding: 'utf-8', timeout: 5000 }
    );
  } catch { return null; }
}

function validate() {
  const issues = [];
  const files = listFiles(WORKSPACE);
  const bootstrapFiles = files.filter(f =>
    ['AGENTS.md','SOUL.md','USER.md','IDENTITY.md','TOOLS.md','HEARTBEAT.md','MEMORY.md','HIPPOCAMPUS.md'].includes(f.path)
  );
  let total = 0;
  for (const f of bootstrapFiles) {
    total += f.size;
    const limit = LIMITS[f.path];
    if (limit && f.size > limit) {
      issues.push({ level: 'warn', file: f.path, msg: `${f.size}B exceeds ${limit}B limit` });
    }
  }
  if (total > TOTAL_WARN) {
    issues.push({ level: 'critical', file: '(total)', msg: `Total bootstrap ${total}B exceeds ${TOTAL_WARN}B` });
  }
  // Check HIPPOCAMPUS staleness
  try {
    const hip = fs.readFileSync(path.join(WORKSPACE, 'HIPPOCAMPUS.md'), 'utf-8');
    const match = hip.match(/Last updated:\s*(\d{4}-\d{2}-\d{2}\s+\d{2}:\d{2})/);
    if (match) {
      const updated = new Date(match[1].replace(' ', 'T') + ':00');
      const hoursAgo = (Date.now() - updated.getTime()) / 3600000;
      if (hoursAgo > 24) issues.push({ level: 'warn', file: 'HIPPOCAMPUS.md', msg: `Stale: last updated ${Math.round(hoursAgo)}h ago` });
    }
  } catch {}
  return { issues, bootstrapTotal: total, bootstrapFiles };
}

function tokenEstimate(bytes) {
  return Math.round(bytes / 4); // rough estimate
}

const server = http.createServer((req, res) => {
  const url = new URL(req.url, `http://localhost:${PORT}`);

  // CORS
  res.setHeader('Access-Control-Allow-Origin', '*');
  res.setHeader('Access-Control-Allow-Methods', 'GET,PUT,OPTIONS');
  res.setHeader('Access-Control-Allow-Headers', 'Content-Type');
  if (req.method === 'OPTIONS') { res.writeHead(204); res.end(); return; }

  // API routes
  if (url.pathname === '/api/files') {
    const files = listFiles(WORKSPACE);
    return json(res, files);
  }

  if (url.pathname.startsWith('/api/file/')) {
    const rel = decodeURIComponent(url.pathname.slice(10));
    const abs = path.resolve(WORKSPACE, rel);
    if (!abs.startsWith(WORKSPACE)) return json(res, { error: 'forbidden' }, 403);

    if (req.method === 'GET') {
      try { return json(res, { content: fs.readFileSync(abs, 'utf-8') }); }
      catch { return json(res, { error: 'not found' }, 404); }
    }
    if (req.method === 'PUT') {
      let body = '';
      req.on('data', c => body += c);
      req.on('end', () => {
        try {
          const { content } = JSON.parse(body);
          fs.mkdirSync(path.dirname(abs), { recursive: true });
          fs.writeFileSync(abs, content);
          return json(res, { ok: true, size: Buffer.byteLength(content) });
        } catch (e) { return json(res, { error: e.message }, 500); }
      });
      return;
    }
  }

  if (url.pathname.startsWith('/api/git/log/')) {
    const rel = decodeURIComponent(url.pathname.slice(13));
    return json(res, gitLog(rel));
  }

  if (url.pathname.startsWith('/api/git/diff/')) {
    const rest = url.pathname.slice(14);
    const slashIdx = rest.indexOf('/');
    const hash = rest.slice(0, slashIdx);
    const rel = decodeURIComponent(rest.slice(slashIdx + 1));
    return json(res, { diff: gitDiff(hash, rel) });
  }

  if (url.pathname.startsWith('/api/git/show/')) {
    const rest = url.pathname.slice(14);
    const slashIdx = rest.indexOf('/');
    const hash = rest.slice(0, slashIdx);
    const rel = decodeURIComponent(rest.slice(slashIdx + 1));
    const content = gitShow(hash, rel);
    return json(res, { content });
  }

  if (url.pathname === '/api/validate') {
    return json(res, validate());
  }

  if (url.pathname === '/api/budget') {
    const v = validate();
    return json(res, {
      bootstrapTotal: v.bootstrapTotal,
      bootstrapTokens: tokenEstimate(v.bootstrapTotal),
      limit: TOTAL_WARN,
      limitTokens: tokenEstimate(TOTAL_WARN),
      files: v.bootstrapFiles.map(f => ({
        ...f,
        tokens: tokenEstimate(f.size),
        limit: LIMITS[f.path] || null,
      })),
    });
  }

  // Serve index.html
  if (url.pathname === '/' || url.pathname === '/index.html') {
    const html = fs.readFileSync(path.join(__dirname, 'index.html'), 'utf-8');
    res.writeHead(200, { 'Content-Type': 'text/html' });
    res.end(html);
    return;
  }

  json(res, { error: 'not found' }, 404);
});

server.listen(PORT, '127.0.0.1', () => {
  console.log(`🧠 Hippocampus Dashboard: http://127.0.0.1:${PORT}`);
});
