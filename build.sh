#!/etc/profiles/per-user/hubert/bin/zsh

# Run the nix build command
nix build .#homeConfigurations.hubert.activationPackage

# Activate the result
./result/activate

# Check if the activation was successful
if [ $? -eq 0 ]; then
  # If successful, delete the file
  rm -rf ./result
  echo "Build and activation successful. Cleaned up the result."
else
  echo "Activation failed. Not deleting the result."
fi

