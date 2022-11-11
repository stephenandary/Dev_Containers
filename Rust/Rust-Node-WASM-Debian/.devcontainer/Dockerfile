# [Choice] Debian OS version (use bullseye on local arm64/Apple Silicon): buster, bullseye
ARG VARIANT="bullseye"
FROM rust:1-${VARIANT}

# [Option] Install zsh
ARG INSTALL_ZSH="true"
# [Option] Upgrade OS packages to their latest versions
ARG UPGRADE_PACKAGES="false"
# Install needed packages and setup non-root user. Use a separate RUN statement to add your own dependencies.
ARG USERNAME=vscode
ARG USER_UID=1000
ARG USER_GID=$USER_UID
ARG CARGO_HOME=/usr/local/cargo
ARG RUSTUP_HOME=/usr/local/rustup
ARG NPM_GLOBAL=/usr/local/share/npm-global
ENV NVM_DIR=/usr/local/share/nvm
ENV NVM_SYMLINK_CURRENT=true \ 
    PATH=${NPM_GLOBAL}/bin:${NVM_DIR}/current/bin:${PATH}
ENV NODE_VERSION=16.10.0
COPY library-scripts/*.sh library-scripts/*.env /tmp/library-scripts/
RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
    # Remove imagemagick due to https://security-tracker.debian.org/tracker/CVE-2019-10131
    && apt-get purge -y imagemagick imagemagick-6-common 
# Install common packages, non-root user, updated lldb, dependencies
RUN bash /tmp/library-scripts/common-debian.sh "${INSTALL_ZSH}" "${USERNAME}" "${USER_UID}" "${USER_GID}" "${UPGRADE_PACKAGES}" "true" "true"
RUN bash /tmp/library-scripts/rust-debian.sh "${CARGO_HOME}" "${RUSTUP_HOME}" "${USERNAME}" "true" "true"
RUN bash /tmp/library-scripts/node-debian.sh "${NVM_DIR}" "${NODE_VERSION}" "${USERNAME}" 
# Configure global npm install location, use group to adapt to UID/GID changes
SHELL ["/bin/zsh", "-c"]
RUN source $NVM_DIR/nvm.sh \
    && nvm alias default ${NODE_VERSION} \ 
    && nvm use default
RUN if ! cat /etc/group | grep -e "^npm:" > /dev/null 2>&1; then groupadd -r npm; fi \
    && usermod -a -G npm ${USERNAME} \
    && umask 0002 \
    && mkdir -p ${NPM_GLOBAL} \
    && touch /usr/local/etc/npmrc \
    && chown ${USERNAME}:npm ${NPM_GLOBAL} /usr/local/etc/npmrc \
    && chmod g+s ${NPM_GLOBAL} \
    # Install eslint
    && su ${USERNAME} -c "umask 0002 && npm install -g eslint" \
    && npm cache clean --force > /dev/null 2>&1 \
    # Install python-is-python3 on bullseye to prevent node-gyp regressions
    && . /etc/os-release \
    && if [ "${VERSION_CODENAME}" = "bullseye" ]; then apt-get -y install --no-install-recommends python-is-python3; fi \
    # Clean up
    && apt-get autoremove -y && apt-get clean -y && rm -rf /var/lib/apt/lists/* /root/.gnupg /tmp/library-scripts

# [Optional] Uncomment this section to install additional OS packages.
# RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
#     && apt-get -y install --no-install-recommends <your-package-list-here>

# [Optional] Uncomment this section to install additional rust packages.
RUN curl https://rustwasm.github.io/wasm-pack/installer/init.sh -sSf | zsh
RUN cargo install cargo-generate
