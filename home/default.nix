{ lib, pkgs, ... }:

{
  config = {
    home-manager.users.dunxen = ./home.nix;
    users.users.dunxen = {
      isNormalUser = true;
      home = "/home/dunxen";
      createHome = true;
      hashedPasswordFile = "/persist/encrypted-passwords/dunxen";
      shell = pkgs.nushell;
      extraGroups = [ "wheel" "disk" "networkmanager" "libvirtd" "qemu-libvirtd" "kvm" "i2c" "plugdev" "wireshark" "docker" "vboxusers" "dialout" ];
      openssh.authorizedKeys.keys = [ ];
    };
    programs._1password.enable = true;
    programs._1password-gui = {
      enable = true;
      polkitPolicyOwners = [ "dunxen" ];
    };
    programs.wireshark = {
      enable = true;
      package = pkgs.wireshark;
    };
  };
}
