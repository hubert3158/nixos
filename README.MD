#
#run the following script
#
# Java support is provided by nvim-java with Lombok, no manual jdtls setup needed.

#rebuilds the the whole config including main configuration for ( work/home)
sudo nixos-rebuild switch --flake .#home --show-trace

#rebuilds the config only using home-manager
#run build.sh  -> okay???



