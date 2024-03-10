# CBR VM

## Initial Setup

We offer support for three formats:

- `qemu`
- `virtualbox`
- `proxmox`

You can build the corresponding images using the following command:

```shell
nix build github:wi2trier/cbr-vm#<format>
```

## Post-Installation Setup

Some things cannot be properly automated using nix, so the following needs to be done manually:

### ProCAKE Demo

- Open IntelliJ IDEA > Get from VCS \
  URL: <https://gitlab.rlp.net/procake/publications/procake-demos-for-cbrkit-eval-iccbr-2024.git> \
  Directory: `~/IdeaProjects/procake-demo`

### CBRkit Demo

- Open PyCharm > Get from VCS \
  URL: <https://github.com/wi2trier/cbrkit-demo.git> \
  Directory: `~/PycharmProjects/cbrkit-demo`
- Confirm default Poetry setup
- Click on Run/Debug Configuration > Edit Configurations > Add new > Python \
  Change script to module: `cbrkit_demo`

## Updating Running Images

To rebuild an image already running, you can use the following command:

```shell
sudo nixos-rebuild switch --flake github:wi2trier/cbr-vm#<format> --refresh
```
