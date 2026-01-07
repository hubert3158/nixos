#
#run the following script
#
#cp -r /nix/store/301k2jhjanl6rr96b9yy9qzcrhjbwgmz-jdt-language-server-1.36.0/share/java/jdtls/config_linux /home/hubert/.jdtls_config
#chmod -R u+w /home/hubert/.jdtls_config



#rebuilds the the whole config including main configuration for ( work/home)
sudo nixos-rebuild switch --flake .#work --show-trace

#rebuilds the config only using home-manager
#run build.sh  -> okay???



