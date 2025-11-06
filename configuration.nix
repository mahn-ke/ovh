# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "ovh-mahn-ke";

  networking.networkmanager.enable = true;
  networking.useDHCP = false;
  networking.defaultGateway = "51.254.44.254";
  networking.nameservers = [ "9.9.9.9" ];
  networking.interfaces."enp1s0f0".ipv4.addresses = [
    {
    address = "51.254.44.34";
    prefixLength = 24;
    }
  ];

  time.timeZone = "Europe/Berlin";
  
  security.sudo.extraRules = [
    {
      groups = [ "wheel" ];
      commands = [ { command = "ALL"; options = [ "NOPASSWD" ]; } ];
    }
  ];

  users.users.root.openssh.authorizedKeys.keys = ["ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIETj6tLBKN9rK2RLDAvghueDgGlD2RFfCGOoOWvTz4zM eddsa-key-20250630"];
  users.users.github = {
    isNormalUser = true;
    openssh.authorizedKeys.keys = ["ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPp09oxMtjTkRUMzfegnHUMoVLMSsjlSa4b8ZSva1s9J agent.github@vincent.mahn.ke"];
    extraGroups = [ "wheel" "docker" ];
  };
  services.openssh.enable = true;
  services.openssh.ports = [ 8474 ];

  services.github-runners = {
    ovh = {
      enable = true;
      name = "ovh";
      tokenFile = "/secrets/runner_token";
      url = "https://github.com/mahn-ke";
    };
  };

  environment.systemPackages = with pkgs; [ unzip zip ];

  virtualisation.docker.rootless = {
    enable = true;
    setSocketVariable = true;
  };

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "25.11"; # Did you read the comment?

}

