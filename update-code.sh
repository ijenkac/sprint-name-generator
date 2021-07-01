#!/usr/bin/env bash
# set -x
sed -i "s/.*span id=\"time\".*/<p style=\"text-align:center;font-size:15\"><span id=\"time\" style=\"font-weight:bold\">$(date -Is)<\\/span><\\/p>/" /tmp/web/index.template.html