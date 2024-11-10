const process = require('process')
const express = require('express')
const app = express()
const port = 8083

process.on('SIGINT', function() {
  console.log( "\nGracefully shutting down from SIGINT (Ctrl-C)" );
  process.exit(0);
});

app.post('/jsapi/data', (req, res) => {
  res.send('This is some data from express')
})

app.listen(port, () => {
  console.log(`App listening on port ${port}`)
})
