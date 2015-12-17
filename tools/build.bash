#!/bin/bash

# Kriegslustig <github@kriegslustig.me>
#yolo

ACTION=${1}
NODE_ENVIRONMENT=${NODE_ENVIRONMENT:-'PRODUCTION'}
PROJECT_ROOT=${PROJECT_ROOT:-./}

start_express () {
  PORT=${1}
  node ${PROJECT_ROOT}src/server/main.js ${PORT} 2>&1
}

comp_browserify () {
  local FILE=${1}
  local DEBUG=''
  if [ -f "${FILE}" ]; then
    echo "${FILE}"
    if [[ ${NODE_ENVIRONMENT} != 'PRODUCTION' ]]; then
      DEBUG="--debug"
    fi
    maybe_make_dir ${PROJECT_ROOT}build/_js
    ${PROJECT_ROOT}node_modules/browserify/bin/cmd.js ${FILE} -t ${DEBUG} babelify > ${PROJECT_ROOT}build/_js/$(basename ${FILE})
  fi
}

js () {
  FILE=${1}
  if [ -f "${FILE}" ]; then
    comp_browserify ${FILE}
  else
    for file in ${PROJECT_ROOT}src/client/js/*; do
      comp_browserify ${file}
    done
  fi
}

riot () {
  maybe_make_dir build/_tag
  if [ -f ${PROJECT_ROOT}src/client/tag/* ]; then
    cp -r ${PROJECT_ROOT}src/client/tag/* ${PROJECT_ROOT}build/_tag/
  fi
}

comp_postcss () {
  FILE=${1}
  if [ -f "${FILE}" ]; then
    maybe_make_dir ${PROJECT_ROOT}build/_css
    postcss --local-plugins --config ${PROJECT_ROOT}tools/postcss.json --dir ${PROJECT_ROOT}build/_css ${FILE}
  fi
}

css () {
  FILE=${1}
  if [ -f "./${FILE}" ]; then
    comp_postcss ${FILE}
  else
    for file in ${PROJECT_ROOT}src/client/css/*; do
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
  if [ ! -d "${DIR}" ]; then
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

