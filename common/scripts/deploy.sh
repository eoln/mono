#!/bin/bash

# setup git for push backs to GitHub
git config --global url."https://api:$GH_TOKEN@github.com/".insteadOf "https://github.com/"

# publish libraries and other packages
node common/scripts/install-run-rush.js publish --target-branch master --publish --npm-auth-token $NPM_AUTH_TOKEN --set-access-level public --apply --add-commit-details
