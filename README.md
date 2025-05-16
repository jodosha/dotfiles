# Dotfiles

## Instructions

### Install Nix

Use [Determinate Systems](https://github.com/DeterminateSystems/nix-installer?tab=readme-ov-file#determinate-nix-installer) installer

```bash
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | \
  sh -s -- install
```

### Get dotfiles

```bash
cd /etc
curl https://github.com/jodosha/dotfiles/archive/refs/heads/master.zip -O nix-darwin.zip
unzip nix-darwin.zip
```

### Install

```bash
cd /etc/nix-darwin
nix run nix-darwin/master#darwin-rebuild -- switch
darwin-rebuild switch
```

### Update

```bash
nix-remote-builder
nix flake update
rebuild
```
