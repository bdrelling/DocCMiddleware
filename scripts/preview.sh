#!/bin/bash

product=${1-'DocCMiddleware'}

swift package --disable-sandbox preview-documentation --target $target
