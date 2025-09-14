#!/bin/bash

# exit immediately on failure, or if an undefined variable is used
set -eu

SUFFIX="$1"

cat <<EOF
steps:
  - command: echo "building \\\$USR_ARCH \\\$USR_PY_VER \\\$USR_CUDA_VER!"
    label: ":construction_worker: build $SUFFIX"
    key: build-$SUFFIX
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

  - command: echo "testing \\\$USR_ARCH \\\$USR_PY_VER \\\$USR_CUDA_VER!"
    label: ":white_check_mark: Test $SUFFIX"
    depends_on:
      - build-$SUFFIX
    matrix:
      setup:
        arch:
          - amd64
          - arm64
        py_ver:
          - "3.10"
          - "3.11"
        cuda_ver:
          - "11.0"
          - "12.0"
    env:
      USR_ARCH: "{{ matrix.arch }}"
      USR_PY_VER: "{{ matrix.py_ver }}"
      USR_CUDA_VER: "{{ matrix.cuda_ver }}"
EOF
