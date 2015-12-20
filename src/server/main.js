var express = require('express')
var fs = require('fs')

var initTLS = require('./tls')

var NODE_ENV = process.env.NODE_ENV

var ports = process.env.NODE_ENV === 'production'
  ? [80, 443]
  : [3042, 3043]
var TLS

var app = express()
initTLS('./tls/key.pem', './tls/cert.pem', app)
  .then((server) => {
    server.listen(ports[1], 'localhost')
    TLS = true
  })
  .catch((err) => TLS = false)
app.listen(ports[0])

app.engine('html', (filePath, options, cb) => {
  fs.readFile(filePath, {encoding: 'utf8'}, cb)
})

app.set('view engine', 'html')
app.set('views', './build/_html')

app.use(express.static('./build/'))

app.use(/^\/$/, (req, res) => {
  res.render('start')
})

