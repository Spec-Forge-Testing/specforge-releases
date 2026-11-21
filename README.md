# Spec Forge releases

Spec Forge turns an API's OpenAPI spec and its source code into property-based fuzzing
runs. This repository only publishes the installers and the binaries. There are three ways
to use it, and each one carries its own core, so none of them needs Python:

| What | For | Current release |
| --- | --- | --- |
| [VS Code extension](#vs-code-extension) | inside the editor | [`vscode-v0.2.0`](https://github.com/Spec-Forge-Testing/specforge-releases/releases/tag/vscode-v0.2.0) |
| [Desktop app](#desktop-app) | a window of its own | [`v0.2.0`](https://github.com/Spec-Forge-Testing/specforge-releases/releases/tag/v0.2.0) |
| [CLI](#cli) | the terminal and CI | [`cli-v0.2.1`](https://github.com/Spec-Forge-Testing/specforge-releases/releases/tag/cli-v0.2.1) |

Older versions are on the [Releases](https://github.com/Spec-Forge-Testing/specforge-releases/releases) page.

## VS Code extension

Download the package for your system from the
[`vscode-v0.2.0` release](https://github.com/Spec-Forge-Testing/specforge-releases/releases/tag/vscode-v0.2.0):

| File | For |
| --- | --- |
| [`spec-forge-win32-x64-0.2.0.vsix`](https://github.com/Spec-Forge-Testing/specforge-releases/releases/download/vscode-v0.2.0/spec-forge-win32-x64-0.2.0.vsix) | Windows x64 |
| [`spec-forge-linux-x64-0.2.0.vsix`](https://github.com/Spec-Forge-Testing/specforge-releases/releases/download/vscode-v0.2.0/spec-forge-linux-x64-0.2.0.vsix) | Linux x64 (glibc 2.28 or later) |

1. In VS Code: `Extensions` → `⋯` → **Install from VSIX…** and pick the file.
2. Open your project folder (the one with `specforge.toml`) as the workspace and run
   `Spec Forge: Open`.

It needs VS Code 1.90 or later and a trusted workspace. There is no macOS package yet.

## Desktop app

Download the installer for your system from the
[`v0.2.0` release](https://github.com/Spec-Forge-Testing/specforge-releases/releases/tag/v0.2.0):

| File | For |
| --- | --- |
| [`Spec.Forge.Desktop_0.2.0_x64-setup.exe`](https://github.com/Spec-Forge-Testing/specforge-releases/releases/download/v0.2.0/Spec.Forge.Desktop_0.2.0_x64-setup.exe) | Windows x64 (the `.msi` installs the same app) |
| [`Spec.Forge.Desktop_0.2.0_amd64.deb`](https://github.com/Spec-Forge-Testing/specforge-releases/releases/download/v0.2.0/Spec.Forge.Desktop_0.2.0_amd64.deb) | Ubuntu 22.04+, Linux Mint 21+, Debian 12+ |

On Linux, install it with `sudo apt install ./Spec.Forge.Desktop_0.2.0_amd64.deb`.

The installers are not signed: Windows may show a SmartScreen or antivirus warning. There
is no macOS build yet.

## CLI

### Install

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
install a specific one. The files themselves are on the
[`cli-v0.2.1` release](https://github.com/Spec-Forge-Testing/specforge-releases/releases/tag/cli-v0.2.1).

Once installed, `specforge update` updates it in place.

### Use

```sh
cd path/to/your-api
specforge
```

The first time in a folder, Spec Forge asks you to trust it and for the API's OpenAPI spec
(a file path or a URL), then creates the project there. After that, `specforge` in the same
folder resumes it.

### Uninstall

```sh
specforge delete
```

It lists what it removes (the binary, its data, settings and cache) and asks first. Your
projects' `specforge.toml` and `.specforge/` folders are left as they are.
