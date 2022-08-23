#!/bin/bash

target=${1-'DocCMiddleware'}

swift package --disable-sandbox preview-documentation --target $target
