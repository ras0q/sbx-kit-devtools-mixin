# sbx-kit-devtools-mixin

A Docker Sandbox v3 mixin for development.

## Use

Requires Docker Sandboxes with v3 kit support. Allow GHCR alongside Docker Hub
(retain any other prefixes you already use):

```sh
sbx settings set kit.allowedSources '["docker.io/", "ghcr.io/ras0q/sbx-kit-devtools-mixin"]'
sbx run docker.io/docker/sbx-kit-shell:1.0.0 \
  --kit ghcr.io/ras0q/sbx-kit-devtools-mixin:main
```

## Configure

- [Tools and environment variables](files/.config/mise/config.toml)
- [Neovim configuration](files/.config/nvim/init.lua)
- [Kit descriptor](devtools.yaml) and [Dockerfile](devtools.dockerfile)

## Build locally

```sh
docker buildx build -f devtools.yaml .
sbx run docker.io/docker/sbx-kit-shell:1.0.0 --kit .
```

## Publish

See [the workflow](.github/workflows/publish.yaml) for build platforms, publish
triggers, and image tags. After the first publish, set the GHCR package visibility
to **Public** so others can pull it anonymously.
