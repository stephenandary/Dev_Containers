#!/usr/bin/env bash
echo "Update apt database"
sudo apt-get update

echo "Adding WASM Targets"
rustup target add wasm32-unknown-unknown
rustup target add wasm32-wasi

echo "Install gpugp2 for gpg key sharing"
apt-get update && apt-get install gnupg2 -y

echo "Installing Hombrew"
NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
echo '# Set PATH, MANPATH, etc., for Homebrew.' >> /home/vscode/.zshrc
echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> /home/vscode/.zshrc
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
sudo apt-get install build-essential

echo "Installing NATS CLI"
brew tap nats-io/nats-tools
brew install nats-io/nats-tools/nats
brew unlink nats && brew link nats

echo "Installing Cargo-Watch"
cargo install cargo-watch

echo "Installing WASMCloud Shell"
curl -s https://packagecloud.io/install/repositories/wasmcloud/core/script.deb.sh | sudo bash
sudo apt install wasmcloud wash

echo "Installing Cosmonic Shell"
bash -c "$(curl -fsSL https://cosmonic.sh/install.sh)"

echo "Installing WABT"
sudo apt-get -y install wabt

echo "Installing Trunk"
cargo install --locked trunk

echo "Installing uuid and psql for WASMcloud petclinic example"
sudo apt-get -y install uuid-runtime
sudo apt-get -y install postgresql

echo "Done!"