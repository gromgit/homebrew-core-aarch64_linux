# Experimental support for Homebrew Core on ARM64 Linux

This repo mirrors the main Homebrew core repo as much as possible, only making concessions to stuff that can no longer be built under ARM64 Linux. I'll provide bottles to the best of my ability.

## How do I install these formulae?

From a **working** Homebrew installation, you first need to change the GitHub remote for the core repo:
```
# Stop `brew` from complaining about the unusual repo URL
export HOMEBREW_CORE_GIT_REMOTE=https://github.com/gromgit/homebrew-core-aarch64_linux
rm -fr $(brew --repo homebrew/core)
brew tap homebrew/core https://github.com/gromgit/homebrew-core-aarch64_linux
```
Then just `brew install <formula>` as usual.

You should also add `export HOMEBREW_CORE_GIT_REMOTE=https://github.com/gromgit/homebrew-core-aarch64_linux` to your shell's startup file, otherwise `brew doctor` will warn you:
```
Warning: Suspicious https://github.com/Homebrew/homebrew-core git origin remote found.
```

## Why is XYZ not the latest version?

Any or all of the following:

1. I don't have a Github-scale infrastructure to build ARM64 Linux bottles, and since there are easily a few dozen new Homebrew releases each day, it may take a while for me to catch up.
2. The latest XYZ may not be available on ARM64 Linux--this will be noted in the Caveats section of `brew info XYZ`.

## Hey, something's not working right.

If you find any problems, please [open an issue here](https://github.com/gromgit/homebrew-core-aarch64_linux/issues/new/choose). Do **NOT** file an issue in the main Homebrew core repo, they have nothing to do with this.

## It's just not my cup of tea. How do I revert to the original Homebrew core?

```
unset HOMEBREW_CORE_GIT_REMOTE
rm -fr $(brew --repo homebrew/core)
brew tap homebrew/core
```

## I'm looking for the original Homebrew README. Where is it?

[Here.](https://github.com/Homebrew/homebrew-core/blob/master/README.md)

