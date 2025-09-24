#!/bin/bash

# exit immediately on failure, or if an undefined variable is used
set -eu

SUFFIX="$1"

cat <<EOF
steps:
  - group: build
    steps:
      - command: echo "building \\\$USR_ARCH \\\$USR_PY_VER \\\$USR_CUDA_VER!"
        group: build
        label: ":construction_worker: build $SUFFIX {{ matrix.arch }} {{ matrix.py_ver}} {{ matrix.cuda_ver }}"
        key: "build-$SUFFIX"
        matrix:
          setup:
            arch:
              - amd64
              - arm64
            py_ver:
              - "3.10"
            cuda_ver:
              - "11.0"
              - "12.0"
        env:
          USR_ARCH: "{{ matrix.arch }}"
          USR_PY_VER: "{{ matrix.py_ver }}"
          USR_CUDA_VER: "{{ matrix.cuda_ver }}"
EOF
