# [Choice] Debian OS version (use bullseye on local arm64/Apple Silicon): buster, bullseye
ARG VARIANT="bullseye"
FROM mcr.microsoft.com/vscode/devcontainers/rust:0-${VARIANT}

# Include lld linker to improve build times either by using environment variable
# RUSTFLAGS="-C link-arg=-fuse-ld=lld" or with Cargo's configuration file (i.e see .cargo/config.toml).
RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
   && apt-get -y install clang lld \
   && apt-get autoremove -y && apt-get clean -y

# Set up trunk and rust build target for Yew.rs, add required and desired packages. 
RUN apt-get -y install build-essential cmake pkg-config ripgrep jq httpie fzf fd-find fasd
RUN rustup target add wasm32-unknown-unknown 
RUN cargo install --locked trunk 
RUN cargo install wasm-bindgen-cli

# Take ownership of /usr/local/cargo to prevent crate download issues. 
# NEEDS TESTING TO VERIFY WORKING - WORKS WHEN DONE MANUALLY AFTER CONTAINER INITIALIZED
RUN chown -R vscode:rustlang /usr/local/cargo
