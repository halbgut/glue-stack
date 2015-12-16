# glue-stack

A simplistic node-based web-stack not compromising fancy frontend tech for speed

The glue-stack is a static-site-generator-ish framework meant to be versatile and scale well.

The served HTML is generated from Handlebars templates (by default). All the dynamic content is rendered using Riot and pulled from the Server using XHR or WebSockets or what ever suits your project best. It should be easily possible to server the HTML-Files using an Nginx-Server and only server request to `/_api` through Express.

```bash
build.bash
server.js
src/
    server/
    client/
        tag/  # Riot Tags
        css/
        js/
            lib/
build/
    _js/
    _tag/
    _css/
    _html/
```

