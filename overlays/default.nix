{inputs, ...}: {
  nixpkgs.overlays = [
    # (final: prev: {
    #   flameshot = prev.flameshot.overrideAttrs (old: {
    #     cmakeFlags = (old.cmakeFlags or []) ++ ["-DUSE_WAYLAND_GRIM=ON"];
    #   });
    # })

    # Overlay to disable checks for packages with failing tests
    (import ../nix/neovim-overlay.nix {inherit inputs;})
  ];
}
