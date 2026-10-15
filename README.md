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
[Releases](https://github.com/Spec-Forge-Testing/specforge-releases/releases) page: the CLI's
are the ones tagged `cli-v…`, the others are the desktop app's.

Once installed, `specforge update` updates it in place.

## Use

```sh
cd path/to/your-api
specforge
```

The first time in a folder, Spec Forge asks you to trust it and for the API's OpenAPI spec
(a file path or a URL), then creates the project there. After that, `specforge` in the same
folder resumes it.

## Uninstall

```sh
specforge delete
```

It lists what it removes (the binary, its data, settings and cache) and asks first. Your
projects' `specforge.toml` and `.specforge/` folders are left as they are.
