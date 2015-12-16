#!/usr/bin/env node

var gaze = require('gaze')
var spawn_child = require('child_process').spawn

var express = spawn('./build.bash', ['start'])

function spawn () {
  var child = spawn_child.apply(null, arguments)
  child.stdout.pipe(process.stdout)
  child.stderr.pipe(process.stderr)
  return child
}

gaze('src/client/js/**/*.js', (err, watcher) => {
  if(err) console.error(err)
  watcher.on('all', () => {
    spawn('./build.bash', ['js'])
  })
})

gaze(['src/server/**/*.js', 'server.js'], (err, watcher) => {
  if(err) console.error(err)
  watcher.on('all', () => {
    express.kill()
    express.on('close', () => spawn('./build.bash', ['start']))
  })
})

gaze('src/client/css/**/*.css', (err, watcher) => {
  if(err) console.error(err)
  watcher.on('all', () => {
    spawn('./build.bash', ['css'])
  })
})

gaze('src/client/tag/**/*.tag', (err, watcher) => {
  if(err) console.error(err)
  watcher.on('all', () => {
    spawn('./build.bash', ['riot'])
  })
})
