{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.services.keylime;
  format = pkgs.formats.ini {};
  #configFile = format.generate "ca.conf" cfg.settings.ca;
  configFileRegistrar = format.generate "registrar.conf" cfg.registrar.settings;
in
{
  options = {
    services.keylime = {
      enable = mkOption {
        default = false;
        type = types.bool;
        description = lib.mdDoc "Whether to enable keylime services.";
      };

      registrar = {
        enable = mkOption {
          default = false;
          type = types.bool;
          description = lib.mdDoc "Whether to enable keylime-registrar service.";
        };

        settings = mkOption {
          description = mdDoc ''
            Configuration options for various keylime services
          '';
          default = {};
          type = types.submodule {
            freeformType = format.type;
            options.registrar = {
              version = mkOption {
                type = types.str;
                default = "2.0";
                description = mdDoc ''
                  Configuration file version number.
                '';
              };

              ip = mkOption {
                type = types.str;
                default = "127.0.0.1";
                description = mdDoc ''
                  Registrar server IP address.
                '';
              };

              port = mkOption {
                type = types.port;
                default = 8890;
                description = mdDoc ''
                  Registrar server port.
                '';
              };

              tls_port = mkOption {
                type = types.port;
                default = 8891;
                description = mdDoc ''
                  Registrar tls port.
                '';
              };

              tls_dir = mkOption {
                type = types.str or types.path;
                default = "default";
                description = mdDoc ''
                  The 'tls_dir' option define the directory where the keys and certificates are
                  stored.

                  If set as 'generate', automatically generate a CA, keys, and certificates for
                  the registrar server in the /var/lib/keylime/reg_ca directory, if not present.

                  The 'server_key', 'server_cert', and 'trusted_client_ca' options should all be
                  set with the 'default' keyword when 'generate' keyword is set for 'tls_dir'.

                  If set as 'default', share the files with the verifier by using the
                  '/var/lib/keylime/cv_ca' directory, which should contain the files indicated by
                  the 'server_key', 'server_cert', and 'trusted_client_ca' options.
                '';
              };

              server_key = mkOption {
                type = types.str or types.path;
                default = "default";
                description = mdDoc ''
                  The name of the file containing the Keylime registrar server private key.
                  The file should be stored in the directory set in the 'tls_dir' option.
                  This private key is used to serve the Keylime registrar REST API

                  If set as 'default', the 'server-private.pem' value is used.
                '';
              };

              server_key_password = mkOption {
                type = types.str;
                default = "";
                description = mdDoc ''
                  Set the password used to decrypt the private key file.
                  If 'tls_dir = generate', this password will also be used to protect the
                  generated server private key.
                  If left empty, the private key will not be encrypted.
                '';
              };

              server_cert = mkOption {
                type = types.str or types.path;
                default = "default";
                description = mdDoc ''
                  The name of the file containing the Keylime registrar server certificate.
                  The file should be stored in the directory set in the 'tls_dir' option.

                  If set as 'default', the 'server-cert.crt' value is used.
                '';
              };

              trusted_client_ca = mkOption {
                type = types.str or types.path;
                default = "default";
                description = mdDoc ''
                  The list of trusted client CA certificates.
                  The files in the list should be stored in the directory set in the 'tls_dir'
                  option.

                  If set as 'default', the value is set as '[cacert.crt]'
                '';
              };

              database_url = mkOption {
                type = types.str;
                default = "sqlite";
                description = mdDoc ''
                  Database URL Configuration
                  See this document https://keylime.readthedocs.io/en/latest/installation.html#database-support
                  for instructions on using different database configurations.

                  An example of database_url value for using sqlite:
                  sqlite:////var/lib/keylime/reg_data.sqlite
                  An example of database_url value for using mysql:
                  mysql+pymysql://keylime:keylime@keylime_db:[port]/registrar?charset=utf8

                  If set as 'sqlite' keyword, will use the configuration set by the file located
                  at "/var/lib/keylime/reg_data.sqlite".
                '';
              };

              database_pool_sz_ovfl = mkOption {
                type = types.str;
                default = "5,10";
                description = mdDoc ''
                  Limits for DB connection pool size in sqlalchemy
                  (https://docs.sqlalchemy.org/en/14/core/pooling.html#api-documentation-available-pool-implementations)
                '';
              };

              auto_migrate_db = mkOption {
                type = types.bool;
                default = true;
                description = mdDoc ''
                  Whether to automatically update the DB schema using alembic
                '';
              };

              prov_db_filename = mkOption {
                type = types.str;
                default = "provider_reg_data.sqlite";
                description = mdDoc ''
                  The file to use for SQLite persistence of provider hypervisor data.
                '';
              };

              durable_attestation_import = mkOption {
                type = types.str;
                default = "";
                description = mdDoc ''
                  Durable Attestation is currently marked as an experimental feature
                  In order to enable Durable Attestation, an "adapter" for a Persistent data Store
                  (time-series like database) needs to be specified. Some example adapters can be
                  found under "da/examples" so, for instance
                  "durable_attestation_import = keylime.da.examples.redis.py"
                  could be used to interact with a Redis (Persistent data Store)
                '';
              };

              persistent_store_url = mkOption {
                type = types.str;
                default = "";
                description = mdDoc ''
                '';
              };

              transparency_log_url = mkOption {
                type = types.str;
                default = "";
                description = mdDoc ''
                '';
              };

              time_stamp_authority_url = mkOption {
                type = types.str;
                default = "";
                description = mdDoc ''
                '';
              };

              time_stamp_authority_certs_path = mkOption {
                type = types.str;
                default = "";
                description = mdDoc ''
                '';
              };

              persistent_store_format = mkOption {
                type = types.str;
                default = "json";
                description = mdDoc ''
                '';
              };

              persistent_store_encoding = mkOption {
                type = types.str;
                default = "";
                description = mdDoc ''
                '';
              };

              transparency_log_sign_algo = mkOption {
                type = types.str;
                default = "sha256";
                description = mdDoc ''
                '';
              };

              signed_attributes = mkOption {
                type = types.str;
                default = "ek_tpm,aik_tpm,ekcert";
                description = mdDoc ''
                '';
              };
            };
          };
        };
      };

      verifier = {
        enable = mkOption {
          default = false;
          type = types.bool;
          description = lib.mdDoc "Whether to enable keylime-verifier service.";
        };
      };

      user = mkOption {
        type = types.str;
        default = "keylime";
        description = lib.mdDoc "User which runs keylime.";
      };

      group = mkOption {
        type = types.str;
        default = "keylime";
        description = lib.mdDoc "Group which runs keylime.";
      };
    };
  };

  config = mkIf cfg.enable (mkMerge [
    {
      environment.etc."keylime/tenant.conf".source = "${pkgs.keylime}/etc/config/tenant.conf";

      users.users.keylime = {
        description = "Keylime user";
        extraGroups = [ "${cfg.group}" ];
        isSystemUser = true;
      };

      users.groups.${cfg.group} = {};
    }

    (mkIf cfg.registrar.enable {
      #environment.etc."keylime/registrar.conf".source = "${pkgs.keylime}/etc/config/registrar.conf";
      environment.etc."keylime/registrar.conf".source = configFileRegistrar;#"${pkgs.keylime}/etc/config/registrar.conf";
      environment.etc."keylime/logging.conf".source = "${pkgs.keylime}/etc/config/logging.conf";

      systemd.services."keylime-registrar" = {
        description = "Keylime registrar service";
        after = [ "network.target" ];
        wantedBy = [ "default.target" ];
        serviceConfig = {
          User = "${cfg.user}";
          Group = "${cfg.group}";
          Restart = "on-failure";
          ExecStart = "${pkgs.keylime}/bin/keylime_registrar";
          TimeoutSec= 60;
          RestartSec= 120;
        };
      };
    })

    (mkIf cfg.verifier.enable {
      environment.etc."keylime/verifier.conf".source = "${pkgs.keylime}/etc/config/verifier.conf";
      environment.etc."keylime/ca.conf".source = "${pkgs.keylime}/etc/config/ca.conf";
      environment.etc."keylime/logging.conf".source = "${pkgs.keylime}/etc/config/logging.conf";

      systemd.services."keylime-verifier" = {
        description = "Keylime verifier service";
        after = [ "network.target" ];
        before = [ "keylime-registrar.service" ];
        wantedBy = [ "default.target" ];
        unitConfig = {
          StartLimitIntervalSec = 10;
          StartLimitBurst = 5;
        };

        serviceConfig = {
          User = "${cfg.user}";
          Group = "${cfg.group}";
          Restart = "on-failure";
          ExecStart = "${pkgs.keylime}/bin/keylime_verifier";
          TimeoutSec= 60;
          RestartSec= 120;
        };
      };
    })
  ]);
}
