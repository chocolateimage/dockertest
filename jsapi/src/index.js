const express = require('express')
const app = express()
const port = 8083

app.post('/jsapi/data', (req, res) => {
  res.send('This is some data from express')
})

app.listen(port, () => {
  console.log(`App listening on port ${port}`)
})
