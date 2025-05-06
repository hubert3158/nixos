{inputs, ...}: {
  nixpkgs.overlays = [
    (final: prev: {
      flameshot = prev.flameshot.overrideAttrs (old: {
        cmakeFlags = (old.cmakeFlags or []) ++ ["-DUSE_WAYLAND_GRIM=ON"];
      });
    })

    (import ../nix/neovim-overlay.nix {inherit inputs;})
  ];
}
