{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.services.keylime;
in
{
  options = {
    services.keylime = {
      enable = mkOption {
        default = false;
        type = types.bool;
        description = lib.mdDoc "Whether to enable keylime service.";
      };
    };
  };

  config = mkIf cfg.enable {
    environment.etc."keylime/keylime.conf".source = "${pkgs.keylime}/etc/keylime.conf";
    environment.etc."keylime/verifier.conf".source = "${pkgs.keylime}/etc/config/verifier.conf";
    environment.etc."keylime/tenant.conf".source = "${pkgs.keylime}/etc/config/tenant.conf";
    environment.etc."keylime/registrar.conf".source = "${pkgs.keylime}/etc/config/registrar.conf";
    environment.etc."keylime/ca.conf".source = "${pkgs.keylime}/etc/config/ca.conf";
    environment.etc."keylime/logging.conf".source = "${pkgs.keylime}/etc/config/logging.conf";
  };
}

