var express = require('express')
var fs = require('fs')

// Get the TLS initializer
var initTLS = require('./tls')

// Get the NODE_ENV into this scope
var NODE_ENV = process.env.NODE_ENV

// Set the ports for the app depending on the NODE_ENV
var ports = NODE_ENV === 'production'
  ? [80, 443]
  : [3042, 3043]

// Initialize the express app
var app = express()

// Initializing the listeners
initTLS('./tls/key.pem', './tls/cert.pem', app, ports[1])
app.listen(ports[0])

// Create a simple HTML loader as a template engine
app.engine('html', (filePath, options, cb) => {
  fs.readFile(filePath, {encoding: 'utf8'}, cb)
})
app.set('view engine', 'html')
app.set('views', './build/_html')

// Set a static dir
app.use(express.static('./build/'))

app.use(/^\/$/, (req, res) => {
  res.render('start')
})

