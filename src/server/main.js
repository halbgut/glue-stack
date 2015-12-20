var express = require('express')
var fs = require('fs')

var initTLS = require('./tls')

var port = 3042

var app = express()
initTLS('./tls/key.pem', './tls/cert.pem', app)
  .then((server) => server.listen(port, 'localhost'))
  .catch((err) => app.listen(port))

app.engine('html', (filePath, options, cb) => {
  fs.readFile(filePath, {encoding: 'utf8'}, cb)
})

app.set('view engine', 'html')
app.set('views', './build/_html')

app.use(express.static('./build/'))

app.use('/', (req, res) => {
  res.render('start')
})

