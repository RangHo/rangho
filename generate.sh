#!/bin/sh

debug=""
if [ "$1" = "--dry" ]; then
    debug="yes"
    shift
fi

github_token="$1"

log() {
    printf "==== LOG ====\n%s\n=============\n" "$@"
}

setup() {
    # Initialize git
    log "Cloning the target repository..."
    git clone https://github.com/RangHo/rangho deploy
    cd deploy

    log "Setting up a git profile..."
    git config --local user.name "Profile Generator Bot"
    git config --local user.email "profile-generator@rangho.me"
    git remote set-url origin "https://x-access-token:$github_token@github.com/RangHo/rangho"
    
    log "Checking out the deploy branch..."
    git checkout deploy
    cd ..
}

main() {
    # Simply run every file in generators directory
    generators="$(find ./generators -executable -type f | sort)"

    for prog in $generators; do
        log "Running generator: $prog"
        "$prog"
    done
}

cleanup() {
    # Move all required files
    log "Copying generated assets..."
    cp -r assets deploy
    cp README.md deploy

    # Commit the changes
    cd deploy
    if [ -z "$debug" ]; then
        log "Committing changes to upstream..."
        git add --all
        git commit -m "Generate profile"
        git push --force
    fi
    cd ..
}

setup
main
cleanup
