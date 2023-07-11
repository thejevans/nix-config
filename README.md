# nix-config

My configuration for the Nix package manager and operating system.

hostnames are chosen using the random yokai generator [here](https://yokai.com?redirect_to=random)

| hostname   | manufacturer | model           |
| :--------: | :----------: | :-------------: |
| `mujina`   | Framework    | i5-1240p        |
| `kotobuki` | Apple        | Macbook Air 6,1 |

# Organizational structure:

An entry for each system goes in `flake.nix`

System-wide:
- System-wide configuration goes in `host-common.nix` if it will be used on all systems
- Each system has a `host-<hostname>` directory with a `default.nix` file and a copy of the system-generated `hardware-configuration.nix` for the given system

`home-manager`:
- configuration that is common for all desktop environments and servers goes in `home-common.nix`
- configuration that is common for all desktop environments, but not for servers goes in `home-desktop/common.nix`
- configuration for specific desktop environments go in `home-desktop/<desktop environment>.nix`

Userspace non-`home-manager` configurations:
- configuration that is common for all desktop environments and servers goes in `userspace-common.nix`
- configuration that is common for all desktop environments, but not for servers goes in `userspace-desktop/common.nix`
- configuration for specific desktop environments go in `userspace-desktop/<desktop environment>.nix`

Currently, there are no servers configured, but when set up, I will add `home-server` and `userspace-server` directories if necessary. My guess is that most configuration for servers will be system-wide, though.

Application configuration through `home-manager` will likely require another directory system.
