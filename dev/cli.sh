export VSCODE_CLI_APP_NAME="glider"
export VSCODE_CLI_BINARY_NAME="glider-server"
export VSCODE_CLI_DOWNLOAD_URL="https://github.com/GliderOrg/gliderapp/releases"
export VSCODE_CLI_QUALITY="stable"
export VSCODE_CLI_UPDATE_URL="https://raw.githubusercontent.com/GliderOrg/versions/refs/heads/main"

cargo build --release --target aarch64-apple-darwin --bin=code

cp target/aarch64-apple-darwin/release/code "../../VSCode-darwin-arm64/Void.app/Contents/Resources/app/bin/void-tunnel"

"../../VSCode-darwin-arm64/Void.app/Contents/Resources/app/bin/void-tunnel" serve-web


# export CARGO_NET_GIT_FETCH_WITH_CLI="true"
# export VSCODE_CLI_APP_NAME="vscodium"
# export VSCODE_CLI_BINARY_NAME="codium-server-insiders"
# export VSCODE_CLI_DOWNLOAD_URL="https://github.com/GliderOrg/gliderapp-insiders/releases"
# export VSCODE_CLI_QUALITY="insider"
# export VSCODE_CLI_UPDATE_URL="https://raw.githubusercontent.com/VSCodium/versions/refs/heads/master"

# cargo build --release --target aarch64-apple-darwin --bin=code

# cp target/aarch64-apple-darwin/release/code "../../VSCode-darwin-arm64/VSCodium - Insiders.app/Contents/Resources/app/bin/codium-tunnel-insiders"

# "../../VSCode-darwin-arm64/VSCodium - Insiders.app/Contents/Resources/app/bin/codium-insiders" serve-web
