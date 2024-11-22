#!/bin/sh

docker run \
       --rm \
       --env INPUT_TOKEN="${GITHUB_TOKEN}" \
       --env INPUT_USER="RangHo" \
       --env INPUT_TEMPLATE="classic" \
       --env INPUT_BASE="activity, community, repositories, metadata" \
       --env INPUT_CONFIG_TIMEZONE="Asia/Seoul" \
       --env INPUT_PLUGIN_ACHIEVEMENTS="yes" \
       --env INPUT_PLUGIN_ACHIEVEMENTS_DISPLAY="detailed" \
       --env INPUT_PLUGIN_ACHIEVEMENTS_SECRETS="yes" \
       --env INPUT_PLUGIN_ACHIEVEMENTS_THRESHOLD="A" \
       --env INPUT_PLUGIN_CODE="yes" \
       --env INPUT_PLUGIN_CODE_DAYS="3" \
       --env INPUT_PLUGIN_CODE_LINES="12" \
       --env INPUT_PLUGIN_CODE_LOAD="400" \
       --env INPUT_PLUGIN_CODE_VISIBILITY="public" \
       --env INPUT_PLUGIN_ISOCALENDAR="yes" \
       --env INPUT_PLUGIN_ISOCALENDAR_DURATION="half-year" \
       --env INPUT_PLUGIN_LANGUAGES="yes" \
       --env INPUT_PLUGIN_LANGUAGES_ANALYSIS_TIMEOUT="15" \
       --env INPUT_PLUGIN_LANGUAGES_ANALYSIS_TIMEOUT_REPOSITORIES="7.5" \
       --env INPUT_PLUGIN_LANGUAGES_CATEGORIES="markup, programming" \
       --env INPUT_PLUGIN_LANGUAGES_COLORS="github" \
       --env INPUT_PLUGIN_LANGUAGES_LIMIT="8" \
       --env INPUT_PLUGIN_LANGUAGES_RECENT_CATEGORIES="markup, programming" \
       --env INPUT_PLUGIN_LANGUAGES_RECENT_DAYS="14" \
       --env INPUT_PLUGIN_LANGUAGES_RECENT_LOAD="300" \
       --env INPUT_PLUGIN_LANGUAGES_SECTIONS="most-used" \
       --env INPUT_PLUGIN_LANGUAGES_THRESHOLD="0%" \
       --volume=.:/renders \
       ghcr.io/lowlighter/metrics:latest
