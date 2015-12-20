var fs = require('fs')
var https = require('https')

module.exports = (keyPath, certPath, app) => {
  return new Promise((res, rej) => {
    var key
    var cert

    fs.readFile(keyPath, (err, data) => {
      if(err) return rej(err)
      key = data
      if(cert) initTLS(key, cert, app)
    })

    fs.readFile(certPath, (err, data) => {
      if(err) return rej(err)
      cert = data
      if(key) res(initTLS(key, cert, app))
    })
  })
}

function initTLS (key, cert, app) {
  return https.createServer({key, cert}, app)
}

