#!/bin/sh
# Installs Spec Forge for the current user on Linux (Ubuntu 22.04+, Mint 21+). No sudo.
#
#   curl -fsSL https://raw.githubusercontent.com/Spec-Forge-Testing/specforge-releases/master/install.sh | sh
#
# Running it again updates to the latest release. SPECFORGE_VERSION=v0.1.0 pins one.
set -eu

REPO="Spec-Forge-Testing/specforge-releases"
INSTALL_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/specforge"
BIN_DIR="$HOME/.local/bin"

fail() {
    echo "specforge: $1" >&2
    exit 1
}

[ "$(uname -s)" = "Linux" ] || fail "this installer is for Linux; on Windows use install.ps1"
[ "$(uname -m)" = "x86_64" ] || fail "only x86_64 is published, this machine is $(uname -m)"
command -v curl >/dev/null || fail "curl is required"
command -v tar >/dev/null || fail "tar is required"
command -v xz >/dev/null || fail "xz is required (sudo apt install xz-utils)"

version="${SPECFORGE_VERSION:-}"
if [ -z "$version" ]; then
    # /releases/latest redirects to /releases/tag/<version>.
    latest=$(curl -fsSLo /dev/null -w '%{url_effective}' "https://github.com/$REPO/releases/latest")
    version="${latest##*/}"
    case "$version" in
        v*) ;;
        *) fail "no release published yet" ;;
    esac
fi

archive="specforge-$version-linux-x86_64.tar.xz"
tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT

echo "Downloading Spec Forge $version..."
curl -fSL --progress-bar -o "$tmp/$archive" \
    "https://github.com/$REPO/releases/download/$version/$archive" ||
    fail "could not download $archive"
tar -xJf "$tmp/$archive" -C "$tmp"

rm -rf "$INSTALL_DIR"
mkdir -p "$(dirname "$INSTALL_DIR")" "$BIN_DIR"
mv "$tmp/specforge" "$INSTALL_DIR"
ln -sf "$INSTALL_DIR/specforge" "$BIN_DIR/specforge"

echo "Spec Forge $version installed in $INSTALL_DIR"
case ":$PATH:" in
    *":$BIN_DIR:"*) echo "Run 'specforge' inside your API's folder to start." ;;
    *)
        echo "Add $BIN_DIR to your PATH to run 'specforge', for example:"
        echo "  echo 'export PATH=\"\$HOME/.local/bin:\$PATH\"' >> ~/.bashrc && . ~/.bashrc"
        ;;
esac
