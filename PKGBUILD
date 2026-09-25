# Maintainer: Magrid0 <magrid0@proton.me>
# Contributor: 4ndr34p3rry <andreaperrina06@gmail.com>
#
# Builds the Godot project into a standalone Linux binary and installs it
# together with a desktop entry and an XScreenSaver config example.
#
# To build and install from a checkout of this repository:
#   makepkg -si     # see README.md -> Installation -> Linux

pkgname=acquarium64
pkgver=1.0.1
pkgrel=1
pkgdesc="The Jolly Roger Bay aquarium from Super Mario 64 as a screensaver (Godot, GL Compatibility)"
arch=('x86_64')
url="https://github.com/4ndr34p3rry/Aquarium64"
license=('GPL-3.0-or-later')
depends=('libgl' 'libxcursor' 'libxext' 'libxfixes' 'libxinerama' 'libxrandr' 'alsa-lib')
makedepends=('godot' 'curl' 'unzip')
optdepends=('xscreensaver: use Acquarium64 as an actual X11 screensaver')
# The repo has no stable release tags yet, so build from main.
# Once tags are cut, pin this to a tag instead: "$url/archive/v$pkgver.tar.gz".
source=("$url/archive/refs/heads/main.tar.gz")
sha256sums=('SKIP')

# Godot version used to export the game; must be installed as a build dependency.
# Keep in sync with the features listed in project.godot and the system godot package.
_godotver=4.7.2

prepare() {
    # Where Godot looks for export templates; keep it inside $srcdir so it is
    # not required to be pre-installed and does not touch the host's home dir.
    export XDG_DATA_HOME="$srcdir/.godot-data"

    # The official Arch godot package does not ship export templates, so fetch
    # them straight from Godot's release assets (version-pinned).
    local tpz="$srcdir/export_templates.tpz"
    curl -fL -o "$tpz" \
        "https://github.com/godotengine/godot/releases/download/${_godotver}-stable/Godot_v${_godotver}-stable_export_templates.tpz"
    unzip -q "$tpz" -d "$srcdir/godot-templates"
    install -d "$XDG_DATA_HOME/godot/export_templates/${_godotver}.stable"
    cp -a "$srcdir/godot-templates"/templates/* \
        "$XDG_DATA_HOME/godot/export_templates/${_godotver}.stable/"
}

build() {
    export XDG_DATA_HOME="$srcdir/.godot-data"

    cd "$srcdir/Aquarium64-main"
    # Import resources, then export the standalone Linux build using the
    # "Linux" preset defined in export_presets.cfg.
    godot --headless --quit --import
    godot --headless --export-release "Linux" "$srcdir/Acquarium64.x86_64"
}

package() {
    install -Dm755 "$srcdir/Acquarium64.x86_64" "$pkgdir/usr/bin/acquarium64"
    install -Dm644 "$srcdir/Aquarium64-main/packaging/aquarium64.desktop" \
        "$pkgdir/usr/share/applications/aquarium64.desktop"
    install -Dm644 "$srcdir/Aquarium64-main/icon.svg" \
        "$pkgdir/usr/share/icons/hicolor/scalable/apps/acquarium64.svg"
    install -Dm644 "$srcdir/Aquarium64-main/packaging/xscreensaver.conf.example" \
        "$pkgdir/usr/share/doc/acquarium64/xscreensaver.conf.example"
}