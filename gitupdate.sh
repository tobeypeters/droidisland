#!/bin/bash

: <<'LICENSE'
  The MIT License (MIT)
  Copyright (c) Tobey Peters
  See full license at: https://github.com/tobeypeters
LICENSE

: <<'DESCRIPTION'
    Push any changes to inside the current parent or sub folder(s) to GitHub
DESCRIPTION

msg=${1:-"Update"}
git add .
git commit -m "$msg"
git push