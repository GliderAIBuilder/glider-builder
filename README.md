# Glider Builder

This is a fork of VSCodium, which has a nice build pipeline that we're using for Glider. Big thanks to the CodeStory team for inspiring this.

The purpose of this repo is to run [Github Actions](https://github.com/GliderOrg/glider-builder/actions). These actions build all the Glider assets (.dmg, .zip, etc), store them on a release in [`GliderOrg/binaries`](https://github.com/GliderOrg/binaries/releases), and then set the latest version in [`GliderOrg/versions`](https://github.com/GliderOrg/versions) so the versions can be tracked for updating in the Glider app.

## Notes

- See `stable-macos.sh` for one of the main Actions with some comments added by the Glider team.

- VSCodium comes with `.patch` files, including relevant ones to auto-updating, which are being applied when we build Glider.

- For a list of all the places Glider edited in this repo, search "Glider" and "GliderOrg".

- We deleted some unused workflows (insider-\* and stable-spearhead).

## Build locally
- Run `./dev/build/sh` to build binary as per the local machine
