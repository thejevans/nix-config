# nix-config

My configuration for the Nix package manager and operating system.

hostnames are chosen using the random yokai generator [here](https://yokai.com?redirect_to=random)

| hostname   | manufacturer | model           |
| :--------: | :----------: | :-------------: |
| [`mujina`](./hosts/mujina)         | Framework    | i5-1240p        |
| [`kotobuki`](./hosts/kotobuki)     | Apple        | Macbook Air 6,1 |
| [`kubikajiri`](./hosts/kubikajiri) | Custom       | AMD Ryzen 5800X3D, AMD RX7900XTX |

## NixOS Modules

### Generic Hosts

- [global.nix](./hosts/generic/global.nix)
- [personal_workstation.nix](./hosts/generic/personal_workstation.nix)
- [personal_laptop.nix](./hosts/generic/personal_laptop.nix)
- [personal_gaming_desktop.nix](./hosts/generic/personal_gaming_desktop.nix)

### CLI Applications

- [fish.nix](./nixosModules/cli-applications/fish.nix)
- [ld.nix](./nixosModules/cli-applications/ld.nix)

### GUI Applications

- [firefox.nix](./nixosModules/gui-applications/firefox.nix)
- [gaming.nix](./nixosModules/gui-applications/gaming.nix)

### Desktop Environments

- [cosmic.nix](./nixosModules/desktop-environments/cosmic.nix)
- [plasma6.nix](./nixosModules/desktop-environments/plasma6.nix)

## Home Manager Modules

### Generic Hosts

- [personal_workstation.nix](./home/personal_workstation.nix)
- [personal_laptop.nix](./home/personal_laptop.nix)
- [personal_gaming_desktop.nix](./home/personal_gaming_desktop.nix)

### CLI Applications

- [fish.nix](./homeManagerModules/cli-applications/fish.nix)
- [starship.nix](./homeManagerModules/cli-applications/starship.nix)
- [neovim](./homeManagerModules/cli-applications/neovim)
- [pipewire](./homeManagerModules/cli-applications/pipewire)

### GUI Applications

- [firefox](./homeManagerModules/gui-applications/firefox)
- [alacritty.nix](./homeManagerModules/gui-applications/alacritty.nix)

### Desktop Environments

- [cosmic](./homeManagerModules/desktop-environments/cosmic)
- [plasma6.nix](./homeManagerModules/desktop-environments/plasma6.nix)
