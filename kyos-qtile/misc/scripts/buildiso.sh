#!/usr/bin/env bash

command ls | grep "releng" || \
    $(echo "Directory does not contain 'releng'. EXITING!" && exit 1)

doas rm -rf output/
doas mkarchiso -v -w output/ -o output/ releng/
