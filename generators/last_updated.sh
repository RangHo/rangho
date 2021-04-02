#!/bin/sh

badge_content="<a href=\"https://github.com/RangHo/rangho/actions\"><img src=\"https://img.shields.io/badge/Last%20updated-$(env TZ='Asia/Seoul' date +'%D %I:%M %p')-brightgreen?style=flat-square\" alt=\"Last Updated Icon\" /></a>"
sed -i "s#<!-- last_updated -->#$badge_content#" README.md
