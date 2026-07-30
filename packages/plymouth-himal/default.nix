# Himal Himal — Plymouth boot splash
#
# The boot splash used to be stock NixOS (plymouth's default theme), which made
# it the one surface on the machine that didn't speak the design system —
# docs/THEME.md claimed it was themed, and it wasn't. This is a `script`-plugin
# theme built entirely from lib/palette.nix, so boot → SDDM → desktop is one
# continuous look.
#
# The mark is typographic, not pictorial. Cropping the wallpaper into a plate
# was tried first and reads as a screenshot pasted onto the screen — a hard
# rectangle of saturated cyan that isn't a Kanagawa colour, floating on ink.
# Type in crystalBlue on sumiInk0 is the sumi-e answer: the design system's own
# name, set once, with nothing else on the screen.
#
# Assets are rendered at build time (imagemagick) rather than checked in, so
# editing lib/palette.nix recolours the splash with no binary churn in git.
{
  lib,
  stdenvNoCC,
  imagemagick,
  noto-fonts,
  palette,
  colors,
}:

let
  themeName = "himal";

  # Plymouth's script language wants normalized channel floats, not hex.
  inkTop = colors.norm palette.sumiInk0;
  inkBottom = colors.norm palette.sumiInk1;

  script = ''
    // Himal Himal — generated from lib/palette.nix, do not hand-edit.
    // Composition: title mark centred, caption beneath, thin progress rule below.

    Window.SetBackgroundTopColor(${inkTop});
    Window.SetBackgroundBottomColor(${inkBottom});

    screen_w = Window.GetWidth();
    screen_h = Window.GetHeight();

    // ── Himal ──────────────────────────────────────────────────────
    mark.image  = Image("mark.png");
    mark.sprite = Sprite(mark.image);
    mark.x = (screen_w - mark.image.GetWidth())  / 2;
    mark.y = (screen_h - mark.image.GetHeight()) / 2 - 40;
    mark.sprite.SetPosition(mark.x, mark.y, 1);

    // ── ukalo ───────────────────────────────────────────────────
    caption.image  = Image("caption.png");
    caption.sprite = Sprite(caption.image);
    caption.x = (screen_w - caption.image.GetWidth()) / 2;
    caption.y = mark.y + mark.image.GetHeight() + 22;
    caption.sprite.SetPosition(caption.x, caption.y, 1);

    // ── progress rule ───────────────────────────────────────────────────
    bar.width  = 260;
    bar.height = 2;
    bar.x = (screen_w - bar.width) / 2;
    bar.y = caption.y + caption.image.GetHeight() + 48;

    bar.track_sprite = Sprite(Image("bar-track.png").Scale(bar.width, bar.height));
    bar.track_sprite.SetPosition(bar.x, bar.y, 1);

    bar.fill_image  = Image("bar-fill.png");
    bar.fill_sprite = Sprite(bar.fill_image.Scale(1, bar.height));
    bar.fill_sprite.SetPosition(bar.x, bar.y, 2);

    fun on_boot_progress(duration, progress) {
      w = bar.width * progress;
      if (w < 1) w = 1;
      bar.fill_sprite.SetImage(bar.fill_image.Scale(w, bar.height));
    }
    Plymouth.SetBootProgressFunction(on_boot_progress);

    // ── messages ────────────────────────────────────────────────────────
    // Image.Text needs a font that exists inside the initrd; if it isn't there
    // the call yields null, so every use is guarded rather than assumed — a
    // missing font must not take the whole splash down.
    message.sprite = Sprite();
    message.sprite.SetPosition(0, 0, 10);

    fun show_message(text) {
      image = Image.Text(text, ${colors.norm palette.fujiGray}, 1, "Sans 11");
      if (image) {
        message.sprite.SetImage(image);
        message.sprite.SetPosition((screen_w - image.GetWidth()) / 2, bar.y + 40, 10);
      }
    }

    fun hide_message() {
      message.sprite.SetOpacity(0);
    }

    Plymouth.SetMessageFunction(show_message);
    Plymouth.SetDisplayNormalFunction(hide_message);

    // No LUKS on either host today, but an unhandled password prompt is a
    // black screen with no way to know it wants typing — so handle it.
    fun on_password(prompt, bullets) {
      dots = "";
      for (i = 0; i < bullets; i++) dots += "●";
      message.sprite.SetOpacity(1);
      show_message(prompt + "  " + dots);
    }
    Plymouth.SetDisplayPasswordFunction(on_password);

    fun on_quit() {
      mark.sprite.SetOpacity(0);
      caption.sprite.SetOpacity(0);
      bar.track_sprite.SetOpacity(0);
      bar.fill_sprite.SetOpacity(0);
      message.sprite.SetOpacity(0);
    }
    Plymouth.SetQuitFunction(on_quit);
  '';
in
stdenvNoCC.mkDerivation {
  pname = "plymouth-theme-himal";
  version = "1.0";

  dontUnpack = true;

  nativeBuildInputs = [ imagemagick ];

  passAsFile = [ "scriptText" ];
  scriptText = script;

  buildPhase = ''
    runHook preBuild

    # imagemagick shells out to fontconfig, which wants a writable cache dir
    export HOME="$NIX_BUILD_TOP"

    # Located with find rather than a glob: a hand-written glob silently
    # yields an empty -font argument if the package layout ever shifts.
    #
    # Devanagari is safe on this surface even though the initrd carries no
    # fonts: both marks are rasterised to PNG here, at build time. Only the
    # runtime status messages below go through Image.Text, and those are ASCII.
    font="$(find ${noto-fonts}/share/fonts -name 'NotoSansDevanagari.ttf' | head -n1)"
    [ -n "$font" ] || { echo "Noto Sans Devanagari font not found" >&2; exit 1; }

    # Himal — the design system's own name, crystalBlue on ink
    magick -background none -fill '${palette.crystalBlue}' \
      -font "$font" -pointsize 68 -kerning 6 \
      label:'॥ हिमाल ॥' \
      mark.png

    # ukalo — the climb; same line as the lock screen and SDDM
    magick -background none -fill '${palette.fujiGray}' \
      -font "$font" -pointsize 18 -kerning 2 \
      label:'॥ उ का लो ॥' \
      caption.png

    # progress rule: sumiInk4 track, crystalBlue fill (scaled at runtime)
    magick -size 8x8 xc:'${palette.sumiInk4}'    bar-track.png
    magick -size 8x8 xc:'${palette.crystalBlue}' bar-fill.png

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    dir="$out/share/plymouth/themes/${themeName}"
    mkdir -p "$dir"
    cp mark.png caption.png bar-track.png bar-fill.png "$dir/"
    cp "$scriptTextPath" "$dir/${themeName}.script"

    # NixOS rewrites the store path here when it builds the initrd copy
    # (nixos/modules/system/boot/plymouth.nix), so it must be absolute.
    cat > "$dir/${themeName}.plymouth" <<EOF
[Plymouth Theme]
Name=Himal
Description=Himal boot splash, Kanagawa Wave palette (docs/THEME.md)
ModuleName=script

[script]
ImageDir=$dir
ScriptFile=$dir/${themeName}.script
EOF

    runHook postInstall
  '';

  meta = {
    description = "Himal Plymouth boot splash (Kanagawa Wave palette)";
    platforms = lib.platforms.linux;
  };
}
