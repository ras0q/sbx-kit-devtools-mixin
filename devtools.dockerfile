# syntax=docker/dockerfile:1
FROM ghcr.io/jdx/mise:2026.10.25-debian AS build
ENV MISE_DATA_DIR=/home/agent/.local/share/mise \
    MISE_CONFIG_DIR=/home/agent/.config/mise \
    MISE_CACHE_DIR=/tmp/mise-cache
COPY ./files/.config/mise/ /home/agent/.config/mise/
RUN mise install

FROM scratch
LABEL org.opencontainers.image.source="https://github.com/ras0q/sbx-kit-devtools-mixin"
COPY --from=build /usr/local/bin/mise /usr/local/bin/mise
COPY --from=build --chown=1000:1000 /home/agent/.local/share/mise/ /home/agent/.local/share/mise/
COPY --chown=1000:1000 ./files/.config/ /home/agent/.config/
ENV PATH="/home/agent/.local/share/mise/shims:${PATH}"
COPY <<'EOF' /etc/profile.d/mise.sh
eval "$(mise activate bash)"
EOF
