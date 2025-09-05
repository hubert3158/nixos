# NixOS Configuration

This setup uses [nvim-java](https://github.com/nvim-java/nvim-java) for Java
support with Lombok. Spring Boot tooling is disabled by default to avoid
missing module errors on NixOS.

#rebuilds the the whole config including main configuration for ( work/home)
sudo nixos-rebuild switch --flake .#home --show-trace

#rebuilds the config only using home-manager
#run build.sh  -> okay???



