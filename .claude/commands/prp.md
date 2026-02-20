# Pull Request Preparation

Prepare a pull request for the current branch by performing these steps:

1. **Run tests**: Execute `rush test` and ensure all tests pass
2. **Run build**: Execute `rush rebuild --verbose` and ensure build succeeds
3. **Check for changelog**: Run `rush change -v` to verify changelog entries exist
4. **Review changes**: Run `git diff master...HEAD` to review all commits on this branch
5. **Generate PR description**: Based on the diff, create a PR with:
   - A concise title following conventional commit style
   - Summary of what changed and why
   - Test plan describing how to verify the changes
6. **Create the PR**: Use `gh pr create` with the generated title and description

If tests or build fail, fix the issues before proceeding. If `rush change` reports missing changelogs, run `rush change` interactively to add them.

Use the current branch name and target `master` as the base branch.
