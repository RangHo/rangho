#!/bin/sh

time_string=$(env TZ='Asia/Seoul' date +'%D %I:%M %p')
badge_content="<a href=\"https://github.com/RangHo/rangho/actions\"><img src=\"https://img.shields.io/badge/Last%20updated-$time_string KST-brightgreen?style=flat-square\" alt=\"Last Updated on $time_string, Korea Standard Time.\" /></a>"
sed -i "s#<!-- REPLACE WITH last_updated -->#$badge_content#" README.md
