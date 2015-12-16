# Kriegslustig <github@kriegslustig.me>
#yolo

ACTION=${1}
NODE_ENVIRONMENT=${NODE_ENVIRONMENT:-'PRODUCTION'}

start_express () {
  PORT=${1}
  node server.js ${PORT} 2>&1
}

browserify () {
    local FILE=${1}
    local DEBUG=''
    if [[ ${NODE_ENVIRONMENT} != 'PRODUCTION' ]]; then
      DEBUG="--debug"
    fi
    maybe_make_dir build/_js
    node_modules/browserify/bin/cmd.js ${FILE} -t ${DEBUG} babelify build/_js/$(basename ${file})
}

js () {
  FILE=${1}
  if [ -f ${FILE} ]; then
    browserify ${FILE}
  else
    for file in src/client/js/*; do
      browserify ${file}
    done
  fi
}

riot () {
  maybe_make_dir build/_tag
  cp -a src/client/tag/* build/_tag/
}

css () {
  maybe_make_dir build/_css
  cp -a src/client/css/* build/_css/
}

build () {
  js
  css
  riot
}

maybe_make_dir () {
  DIR=${1}
  if [ ! -d ${DIR} ]; then
    mkdir -p ${DIR}
  fi
}

if [[ ${ACTION} == 'js' ]]; then
  js ${2}
elif [[ ${ACTION} == 'css' ]]; then
  css ${2}
elif [[ ${ACTION} == 'riot' ]]; then
  riot ${2}
elif [[ ${ACTION} == 'start' ]]; then
  start_express ${2}
else
  build
fi

