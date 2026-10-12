# Spec Forge releases

Spec Forge turns an API's OpenAPI spec and its source code into property-based fuzzing
runs. This repository only publishes the installers and the binaries — the CLI and its core
in one executable, no Python needed.

## Install

**Linux** (Ubuntu 22.04+, Linux Mint 21+):

```sh
curl -fsSL https://raw.githubusercontent.com/Spec-Forge-Testing/specforge-releases/master/install.sh | sh
```

**Windows** (PowerShell):

```powershell
powershell -c "irm https://raw.githubusercontent.com/Spec-Forge-Testing/specforge-releases/master/install.ps1 | iex"
```

Both install for the current user, without `sudo` or administrator rights. Running the same
command again updates to the latest release; set `SPECFORGE_VERSION` (e.g. `v0.1.0`) to
install a specific one. Every release is also on the
[Releases](https://github.com/Spec-Forge-Testing/specforge-releases/releases) page.

## Use

```sh
cd path/to/your-api
specforge
```

The first time in a folder, Spec Forge asks you to trust it and for the API's OpenAPI spec
(a file path or a URL), then creates the project there. After that, `specforge` in the same
folder resumes it.

## Uninstall

- **Linux:** `rm -rf ~/.local/share/specforge ~/.local/bin/specforge`
- **Windows:** delete `%LOCALAPPDATA%\specforge` and remove it from your user `Path`.
