#!/bin/sh

badge_content="<img src=\"https://img.shields.io/badge/Last%20updated-$(date +'%m/%d/%Y')-brightgreen?style=flat-square\" alt=\"Last Updated Icon\" />"
sed -i "s#<!-- last_updated -->#$badge_content#" README.md
