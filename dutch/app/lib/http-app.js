const express = require('express');
const fs = require('fs');
const path = require('path');


function escapeHtml(value) {
  return String(value || '')
    .replace(/&/g, '&amp;')
    .replace(/</g, '&lt;')
    .replace(/>/g, '&gt;')
    .replace(/"/g, '&quot;')
    .replace(/'/g, '&#39;');
}

function safeLogFileName(name) {
  return path.basename(String(name || '')).replace(/[^A-Za-z0-9._-]/g, '');
}

function htmlPage(title, body, assetVersion = '') {
  return `<!doctype html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>${escapeHtml(title)}</title>
  <link rel="stylesheet" href="/styles.css${assetVersion ? '?v=' + encodeURIComponent(assetVersion) : ''}">
</head>
<body>
  ${body}
</body>
</html>`;
}

function createHttpApp({ indexPath, publicDir, appVersion, gameLogDir }) {
  const app = express();

  app.get('/', (req, res) => {
    fs.readFile(indexPath, 'utf8', (error, html) => {
      if (error) {
        res.status(500).send('Could not load app.');
        return;
      }
      const versionedHtml = html
        .replace('href="styles.css"', 'href="styles.css?v=' + appVersion + '"')
        .replace('src="shared.js"', 'src="shared.js?v=' + appVersion + '"')
        .replace('src="client-actions.js"', 'src="client-actions.js?v=' + appVersion + '"')
        .replace('src="client.js"', 'src="client.js?v=' + appVersion + '"');
      res.set('Cache-Control', 'no-cache');
      res.type('html').send(versionedHtml);
    });
  });

  app.get('/logs', (req, res) => {
    fs.readdir(gameLogDir, { withFileTypes: true }, (error, entries) => {
      const files = error ? [] : entries
        .filter((entry) => entry.isFile() && entry.name.endsWith('.txt'))
        .map((entry) => entry.name)
        .sort()
        .reverse();
      const list = files.length > 0
        ? files.map((fileName) => '<li><a href="/logs/' + encodeURIComponent(fileName) + '">' + escapeHtml(fileName) + '</a></li>').join('')
        : '<li>No saved game logs yet.</li>';
      const note = error && error.code !== 'ENOENT'
        ? '<p class="hint">Could not read ' + escapeHtml(gameLogDir) + ': ' + escapeHtml(error.message) + '</p>'
        : '<p class="hint">Saved as text files in ' + escapeHtml(gameLogDir) + '.</p>';
      res.type('html').send(htmlPage('Dutch game logs',
        '<main class="logs-page">' +
          '<h1>Dutch game logs</h1>' +
          note +
          '<ol class="saved-log-list">' + list + '</ol>' +
          '<p><a href="/">Back to game</a></p>' +
        '</main>',
        appVersion
      ));
    });
  });

  app.get('/logs/:fileName', (req, res) => {
    const fileName = safeLogFileName(req.params.fileName);
    if (!fileName || fileName !== req.params.fileName || !fileName.endsWith('.txt')) {
      res.status(404).type('text').send('Log file not found.\n');
      return;
    }
    res.sendFile(path.join(gameLogDir, fileName), (error) => {
      if (error && !res.headersSent) res.status(error.statusCode || 404).type('text').send('Log file not found.\n');
    });
  });

  app.use(express.static(publicDir));

  return app;
}

module.exports = { createHttpApp };
