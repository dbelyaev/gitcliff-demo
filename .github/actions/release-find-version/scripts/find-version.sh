#!/bin/bash

# get the last commit message
last_commit=$(git log -1 --oneline)

# use bash regex matching
if [[ $last_commit =~ .*(hotfix|release)\/v?([0-9]+\.[0-9]+\.[0-9]+)$ ]]; then
    # if found, store the version in an environment variable.
    # in our regex, we have two match groups: the first one is the branch name, second is the version number.
    # BASH_REMATCH is an array that contains the match groups after matching ([0] is the entire string 1,2.. etc are the match groups).
    # Take the second match group, thus [2].
    export VERSION="${BASH_REMATCH[2]}"
    echo "Found version: $VERSION"
    
    # Output to GITHUB_OUTPUT if it's set (i.e., if running in GitHub Actions)
    if [ -n "$GITHUB_OUTPUT" ]; then
        echo "VERSION=$VERSION" >> $GITHUB_OUTPUT
        echo "Found version: $VERSION and added to GITHUB_OUTPUT"
        exit 0
    fi
else
    echo "No matching version found in the last commit message."

    # Output empty version to GITHUB_OUTPUT if it's set
    if [ -n "$GITHUB_OUTPUT" ]; then
        echo "VERSION=" >> $GITHUB_OUTPUT
        echo "Empty version added to GITHUB_OUTPUT"
        exit 1
    fi
fi
