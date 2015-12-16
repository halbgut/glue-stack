# Kriegslustig <github@kriegslustig.me>
#yolo

ACTION=${1}
NODE_ENVIRONMENT=${NODE_ENVIRONMENT:-'PRODUCTION'}

start_express () {
  PORT=${1}
  node server.js ${PORT} 2>&1
}

comp_browserify () {
    local FILE=${1}
    local DEBUG=''
    if [[ ${NODE_ENVIRONMENT} != 'PRODUCTION' ]]; then
      DEBUG="--debug"
    fi
    maybe_make_dir build/_js
    browserify ${FILE} -t ${DEBUG} babelify build/_js/$(basename ${file})
}

js () {
  FILE=${1}
  if [ -f ${FILE} ]; then
    comp_browserify ${FILE}
  else
    for file in src/client/js/*; do
      comp_browserify ${file}
    done
  fi
}

riot () {
  maybe_make_dir build/_tag
  cp -a src/client/tag/* build/_tag/
}

comp_postcss () {
  FILE=${1}
  maybe_make_dir build/_css
  postcss --local-plugins --config postcss.json --dir build/_css ${FILE}
}

css () {
  FILE=${1}
  if [ -f ./${FILE} ]; then
    comp_postcss ${FILE}
  else
    for file in src/client/css/*; do
      comp_postcss ${file}
    done
  fi
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

