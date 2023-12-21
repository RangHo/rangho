#!/bin/sh

debug=""
if [ "$1" = "--dry" ]; then
    debug="yes"
    shift
fi

github_token="$1"

log() {
    printf "\033[33m%s\033[39m\n" "$@"
}

setup() {
    # Install Python dependencies
    pip install -r requirements.txt
    
    # Initialize git
    log "Cloning the target repository..."
    git clone https://github.com/RangHo/rangho deploy
    cd deploy

    log "Setting up a git profile..."
    git config --local user.name "github-actions[bot]"
    git config --local user.email "41898282+github-actions[bot]@users.noreply.github.com"
    git remote set-url origin "https://x-access-token:$github_token@github.com/RangHo/rangho"
    
    log "Checking out the deploy branch..."
    git checkout deploy
    cd ..
}

main() {
    # Simply run every file in generators directory
    generators="$(find ./generators -executable -type f | sort)"

    log "Running generators..."
    for prog in $generators; do
        "$prog" && log " -> Completed: $prog"
    done
}

cleanup() {
    # Move all required files
    log "Listing generated assets..."
    assets="$(git ls-files --others --exclude-standard)"
    log " -> Detected assets: $assets"

    log "Moving generated assets..."
    for asset in $assets; do
        mv "$asset" deploy && log " -> Moved: $asset"
    done

    # Commit the changes
    log "Committing changes to upstream..."
    cd deploy
    git add --all
    git commit -m "chore: update profile [skip ci]" && log " -> Commit successful"

    log "Pushing changes to upstream..."
    if [ -z "$debug" ]; then
        git push --force && log " -> Push successful"
    else
        log " -> Push skipped (dry run)"
    fi
    cd ..
}

setup
main
cleanup
