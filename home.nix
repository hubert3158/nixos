{
  config,
  pkgs,
  lib,
  ...
}: {
  fileSystems."/nix/store" = {
    device = "/dev/disk/by-uuid/9c498fa9-290c-44ef-914f-aa0987369009";
    fsType = "ext4";
    options = ["defaults"];
  };
}
