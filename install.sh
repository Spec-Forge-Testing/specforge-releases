#!/bin/sh
# Installs Spec Forge for the current user on Linux (Ubuntu 22.04+, Mint 21+) and macOS
# (Apple Silicon and Intel). No sudo.
#
#   curl -fsSL https://raw.githubusercontent.com/Spec-Forge-Testing/specforge-releases/master/install.sh | sh
#
# Running it again updates to the latest release. SPECFORGE_VERSION=v0.1.0 pins one.
#
# The CLI's releases are tagged cli-v<version>: the desktop app publishes here too, under
# v<version>, so "latest" may well be one of its releases and never the CLI's.
set -eu

REPO="Spec-Forge-Testing/specforge-releases"
INSTALL_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/specforge"
BIN_DIR="$HOME/.local/bin"

fail() {
    echo "specforge: $1" >&2
    exit 1
}

# The archive each machine needs, named as the release names it.
system=$(uname -s)
machine=$(uname -m)
case "$system-$machine" in
    Linux-x86_64) platform="linux-x86_64" ;;
    Darwin-arm64) platform="macos-arm64" ;;
    Darwin-x86_64) platform="macos-x86_64" ;;
    Linux-* | Darwin-*) fail "no build is published for $system on $machine" ;;
    *) fail "this installer is for Linux and macOS; on Windows use install.ps1" ;;
esac
command -v curl >/dev/null || fail "curl is required"
command -v tar >/dev/null || fail "tar is required"
# macOS's tar reads xz on its own; GNU tar hands it to the xz program.
[ "$system" = "Darwin" ] || command -v xz >/dev/null || fail "xz is required (sudo apt install xz-utils)"

version="${SPECFORGE_VERSION:-}"
if [ -z "$version" ]; then
    # The highest cli-v* tag among the published releases.
    # Fetched on its own: in a pipeline, a refused request would pass for an empty list.
    releases=$(curl -fsSL "https://api.github.com/repos/$REPO/releases?per_page=100") ||
        fail "could not list the releases (GitHub may be limiting this network); set SPECFORGE_VERSION, e.g. v0.2.2, to skip the lookup"
    version=$(printf '%s\n' "$releases" |
        sed -n 's/.*"tag_name": *"cli-\(v[0-9][0-9.]*\)".*/\1/p' | sort -V | tail -n 1)
    [ -n "$version" ] || fail "no release published yet"
fi
version="v${version#v}"

archive="specforge-$version-$platform.tar.xz"
tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT

echo "Downloading Spec Forge $version..."
curl -fSL --progress-bar -o "$tmp/$archive" \
    "https://github.com/$REPO/releases/download/cli-$version/$archive" ||
    fail "could not download $archive (does release $version have a build for $platform?)"
tar -xJf "$tmp/$archive" -C "$tmp"

rm -rf "$INSTALL_DIR"
mkdir -p "$(dirname "$INSTALL_DIR")" "$BIN_DIR"
mv "$tmp/specforge" "$INSTALL_DIR"
# The macOS builds are not signed: without this, a quarantined download would be blocked.
[ "$system" != "Darwin" ] || xattr -dr com.apple.quarantine "$INSTALL_DIR" 2>/dev/null || true
ln -sf "$INSTALL_DIR/specforge" "$BIN_DIR/specforge"

echo "Spec Forge $version installed in $INSTALL_DIR"
case ":$PATH:" in
    *":$BIN_DIR:"*) echo "Run 'specforge' inside your API's folder to start." ;;
    *)
        echo "Add $BIN_DIR to your PATH to run 'specforge', for example:"
        case "${SHELL:-}" in
            */zsh) profile="~/.zshrc" ;;
            *) profile="~/.bashrc" ;;
        esac
        echo "  echo 'export PATH=\"\$HOME/.local/bin:\$PATH\"' >> $profile && . $profile"
        ;;
esac
