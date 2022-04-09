'use strict';

const express = require('express');

// Constants
const PORT = 8080;
const HOST = '0.0.0.0';

// App
const app = express();
app.get('/', (req, res) => {
  res.send('Hello from crackito');
});

// https://stackoverflow.com/questions/36637912/how-to-stop-running-node-in-docker
// https://docs.docker.com/compose/faq/#:~:text=Compose%20stop%20attempts%20to%20stop,they%20receive%20the%20SIGTERM%20signal.
var process = require('process')
process.on('SIGINT', () => {
  console.info("SIGINT received, exiting")
  process.exit(0)
})
process.on('SIGTERM', () => {
  console.info("SIGTERM received, exiting")
  process.exit(0)
})

app.listen(PORT, HOST);
console.log(`Running on http://${HOST}:${PORT}`);