#!/bin/bash

# exit immediately on failure, or if an undefined variable is used
set -eu

SUFFIX="$1"

cat <<EOF
steps:
  - command: echo "building \\\$USR_ARCH \\\$USR_PY_VER \\\$USR_CUDA_VER!"
    label: ":construction_worker: build $SUFFIX {{ matrix.arch }} {{ matrix.py_ver}} {{ matrix.cuda_ver }}"
    key: "build-$SUFFIX-{{ matrix.arch }}-{{ matrix.py_ver }}-{{ matrix.cuda_ver }}"
    matrix:
      setup:
        arch:
          - amd64
          - arm64
        py_ver:
          - "310"
        cuda_ver:
          - "110"
          - "120"
    env:
      USR_ARCH: "{{ matrix.arch }}"
      USR_PY_VER: "{{ matrix.py_ver }}"
      USR_CUDA_VER: "{{ matrix.cuda_ver }}"

  - command: echo "testing \\\$USR_ARCH \\\$USR_PY_VER \\\$USR_CUDA_VER!"
    label: ":white_check_mark: Test $SUFFIX {{ matrix.arch }} {{ matrix.py_ver}} {{ matrix.cuda_ver }}"
    depends_on:
      - "build-$SUFFIX-{{ matrix.arch }}-310-{{ matrix.cuda_ver }}"
    matrix:
      setup:
        arch:
          - amd64
          - arm64
        py_ver:
          - "310"
          - "311"
        cuda_ver:
          - "110"
          - "120"
    env:
      USR_ARCH: "{{ matrix.arch }}"
      USR_PY_VER: "{{ matrix.py_ver }}"
      USR_CUDA_VER: "{{ matrix.cuda_ver }}"
EOF
