{ lib, ... }:

{
  config = {
    services.openssh.enable = lib.mkDefault true;
    services.openssh.settings.PasswordAuthentication = false;
    services.openssh.settings.PermitRootLogin = lib.mkForce "no";
    # Temporary fix for CVE-2024-6387 until  https://github.com/NixOS/nixpkgs/pull/323753 merged.
    services.openssh.settings.LoginGraceTime = 0;

    # We're only going to allow ssh over tailscale
    networking.firewall.allowedTCPPorts = [ 22 ];
    networking.firewall.allowedUDPPorts = [ 22 ];

    services.openssh.hostKeys = [
      {
        path = "/persist/ssh/ssh_host_ed25519_key";
        type = "ed25519";
      }
      {
        path = "/persist/ssh/ssh_host_rsa_key";
        type = "rsa";
        bits = 4096;
      }
    ];
  };
}

