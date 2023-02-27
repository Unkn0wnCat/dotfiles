# Kevin's Dotfiles

This repo contains my personal dotfiles and configurations for my computers.

## NixOS

I use NixOS as my main OS, and for that I have written a few modules in [`nixos/modules`](./nixos/modules).
Are those settings perfect? No, but they are my opinionated defaults. :stuck_out_tongue_winking_eye:

## Useful Commands

*Generate Hash For Password File*

```bash
mkpasswd -m sha-512
```

*Edit / Create SOPS File*

```bash
cd nixos
nix-shell -p sops --run "EDITOR=vim sops shared/secrets/passwords.yaml"
```

*Create New AGE-Key*

```bash
mkdir -p ~/.config/sops/age
nix-shell -p age --run "age-keygen -o ~/.config/sops/age/keys.txt"
```
