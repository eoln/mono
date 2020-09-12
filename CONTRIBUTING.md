# Contributing to EOLN monorepo

> First off, thanks for taking the time to contribute

The following is a set of guidelines for contributing EOLN and its packages.

- [Code of Conduct](./common/CODE_OF_CONDUCT.md)
- Tooling
- Monorepo Layout
- Code Contribution
- CI/CD pipeline

## Tooling
- [Rush.js](https://rushjs.io/) is used to manage the monorepo
- [PNPM](https://pnpm.js.org/) is used as default package manager
- [Coffeescript](https://coffeescript.org/) is used as default language
  
## Monorepo Layout
- `libraries` is the folder where reusable parts of code lives.  
Every library is published as NPM package in `@eoln` scope

## Code Contribution
- [Rush's Getting started](https://rushjs.io/pages/intro/get_started/)
- [Rush's developer tutorial](https://rushjs.io/pages/developer/new_developer/)

### Install Rush in your local environment
```bash
 npm install -g @microsoft/rush
```

### Clone forked repo 
```bash
git clone git@github.com:<your-github-account>/mono.git
```
- `<your-github-account>` is a placeholder for the name of your github account
- how to [Fork a repo](https://docs.github.com/en/github/getting-started-with-github/fork-a-repo)

### Install dependencies for all projects in monorepo
```bash
cd ./mono
rush update
```

### Run unit tests over all projects in monorepo
```bash
rush test
```

### How to make a PR
- read [About pull requests](https://docs.github.com/en/github/collaborating-with-issues-and-pull-requests/about-pull-requests)
- setup `upstream` remote for easy sync
  ```bash
  github remote add upstream git@github.com:eoln/mono.git
  ```
- make a working branch
- do a changes to code
- commit message should keep [conventional format](https://www.conventionalcommits.org/en/v1.0.0/)
- use `rush change` to describe what you've done
- push changes to your forked repo
- make a github PR to upstream repo
