{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.services.keylime-agent;
  format = pkgs.formats.toml {};
  configFile = format.generate "agent.conf" cfg.settings;
in
{
  options = {
    services.keylime-agent = {
      enable = mkOption {
        default = false;
        type = types.bool;
        description = lib.mdDoc "Whether to enable keylime-agent service.";
      };

      stateDir = mkOption {
        type = types.path;
        default = "/var/lib/keylime/";
        defaultText = literalExpression "/var/lib/keylime/";
        description = lib.mdDoc "State directory for keylime";
      };

      user = mkOption {
        type = types.str;
        default = "keylime";
        description = lib.mdDoc "User which runs keylime.";
      };

      group = mkOption {
        type = types.str;
        default = "tss";
        description = lib.mdDoc "Group which runs keylime.";
      };

      settings = mkOption {
        description = mdDoc ''
            Configuration options for keylime agent
        '';
        type = types.submodule {
          freeformType = format.type;
          options.agent = {
            version = mkOption {
              type = types.str;
              default = "2.0";
              description = mdDoc "Configuration file version.";
            };

            uuid = mkOption {
              type = types.str;
              default = "d432fbb3-d2f1-4a97-9ef7-75bd81c00000";
              description = mdDoc "UUID of the agent.";
            };

            ip = mkOption {
              type = types.str;
              default = "127.0.0.1";
              description = mdDoc "Address to bind to.";
            };

            port = mkOption {
              type = types.port;
              default = 9002;
              description = mdDoc "Port to bind to.";
            };

            contact_ip = mkOption {
              type = types.str;
              default = "127.0.0.1";
              description = mdDoc "Address where the verifier and tenant can connect to reach the agent.";
            };

            contact_port = mkOption {
              type = types.port;
              default = 9002;
              description = mdDoc "Port where the verifier and tenant can connect to reach the agent.";
            };

            registrar_ip = mkOption {
              type = types.str;
              default = "127.0.0.1";
              description = mdDoc "Address of registrar server which agent communicate with.";
            };

            registrar_port = mkOption {
              type = types.port;
              default = 8890;
              description = mdDoc "Port of registrar server which agent communicate with.";
            };

            enable_agent_mtls = mkOption {
              type = types.bool;
              default = true;
              description = mdDoc ''
                  To enable mTLS communication between agent, verifier and tenant.
              '';
            };

            keylime_dir = mkOption {
              type = types.path;
              default = "/var/lib/keylime";
              description = mdDoc "Keylime working directory.";
            };

            server_key = mkOption {
              type = types.str or types.path;
              default = "default";
              description = mdDoc ''
                  The name of the file containing the Keylime agent TLS server private key.
                  This private key is used to serve the Keylime agent REST API.
                  A new private key is generated in case it is not found.
                  If set as "default", the "server-private.pem" value is used.
                  If a relative path is set, it will be considered relative from the cfg.stateDir.
                  If an absolute path is set, it is used without change.
              '';
            };

            server_key_password = mkOption {
              type = types.str;
              default = "";
              description = mdDoc "Password used to encrypt the private key file.";
            };

            server_cert = mkOption {
              type = types.str;
              default = "default";
              description = mdDoc ''
                  The name of the file containing the X509 certificate used as the Keylime agent
                  server TLS certificate.
                  This certificate must be self signed.
                  If set as "default", the "server-cert.crt" value is used
                  If a relative path is set, it will be considered relative from the cfg.stateDir.
                  If an absolute path is set, it is used without change.
              '';
            };

            trusted_client_ca = mkOption {
              type = types.str;
              default = "default";
              description = mdDoc ''
                  The CA that signs the client certificates of the tenant and verifier.
                  If set as "default" the "cv_ca/cacert.crt" value, relative from the keylime_dir is used.
                  If a relative path is set, it will be considered relative from the cfg.stateDir.
                  If an absolute path is set, it is used without change.
              '';
            };

            enc_keyname = mkOption {
              type = types.str;
              default = "derived_tci_key";
              description = mdDoc ''
                  The name that should be used for the encryption key, placed in the
                  cfg.stateDir/secure/ directory.
              '';
            };

            dec_payload_file = mkOption {
              type = types.str;
              default = "decrypted_payload";
              description = mdDoc ''
                  The name that should be used for the optional decrypted payload, placed in
                  the cfg.stateDir/secure directory.
              '';
            };

            secure_size = mkOption {
              type = types.str;
              default = "1m";
              description = mdDoc ''
                  The size of the memory-backed tmpfs partition where Keylime stores crypto keys.
                  Use syntax that the 'mount' command would accept as a size parameter for tmpfs.
                  The default value sets it to 1 megabyte.
              '';
            };

            extract_payload_zip = mkOption {
              type = types.bool;
              default = true;
              description = mdDoc ''
                  Whether to allow the agent to automatically extract a zip file in the
                  delivered payload after it has been decrypted, or not. Defaults to "true".
                  After decryption, the archive will be unzipped to a directory in $keylime_dir/secure.
                  Note: the limits on the size of the tmpfs partition set above with the 'secure_size'
                  option will affect this.
              '';
            };

            enable_revocation_notifications = mkOption {
              type = types.bool;
              default = false;
              description = mdDoc ''
                  Whether to listen for revocation notifications from the verifier via zeromq.
                  Note: The agent supports receiving revocation notifications via REST API
                  regardless of the value set here.
              '';
            };

            revocation_actions_dir = mkOption {
              type = types.str;
              default = "/usr/libexec/keylime";
              description = mdDoc "";
            };

            revocation_notification_ip = mkOption {
              type = types.str;
              default = "127.0.0.1";
              description = mdDoc "Address for revocation notification";
            };

            revocation_notification_port = mkOption {
              type = types.port;
              default = 8992;
              description = mdDoc "Port for revocation notification";
            };

            revocation_cert = mkOption {
              type = types.str or types.path;
              default = "default";
              description = mdDoc ''
                  The path to the certificate to verify revocation messages received from the
                  verifier.  The path is relative to cfg.stateDir unless an absolute path is
                  provided (i.e. starts with '/').
                  If set to "default", Keylime will use the file RevocationNotifier-cert.crt
                  from the unzipped payload contents provided by the tenant.
              '';
            };

            revocation_actions = mkOption {
              type = types.str;
              default = "";
              description = mdDoc ''
                  A comma-separated list of executables to run upon receiving a revocation
                  message. Keylime will verify the signature first, then call these executables
                  passing the json revocation message.
                  The executables must be located in the 'revocation_actions_dir' directory.
                  Keylime will also get the list of revocation actions from the file
                  action_list in the unzipped payload contents provided by the verifier.
              '';
            };

            payload_script = mkOption {
              type = types.str or types.path;
              default = "autorun.sh";
              description = mdDoc ''
                  A script to execute after unzipping the tenant payload.
                  Keylime will run it with a /bin/sh environment and with a working directory of
                  cfg.stateDir/secure/unzipped.
              '';
            };

            enable_insecure_payload = mkOption {
              type = types.bool;
              default = false;
              description = mdDoc ''
                  In case mTLS for the agent is disabled and the use of payloads is still
                  required, this option has to be set to "true" in order to allow the agent
                  to start. Details on why this configuration (mTLS disabled and payload enabled)
                  is generally considered insecure can be found on
                  https://github.com/keylime/keylime/security/advisories/GHSA-2m39-75g9-ff5r

              '';
            };

            allow_payload_revocation_actions = mkOption {
              type = types.bool;
              default = true;
              description = mdDoc ''
                  Whether to allow running revocation actions sent as part of the payload.  The
                  default is true and setting as false will limit the revocation actions to the
                  pre-installed ones.
              '';
            };

            tpm_hash_alg = mkOption {
              type = types.enum [ "sha512" "sha384" "sha256" "sha1" ];
              default = "sha256";
              description = mdDoc ''
                  TPM2-specific options: specify the default crypto algorithms to use with a TPM2 for this agent.
              '';
            };

            tpm_encryption_alg = mkOption {
              type = types.enum [ "ecc" "rsa" ];
              default = "rsa";
              description = mdDoc ''
                  TPM2-specific options: specify the default encryption algorithm to use with a TPM2 for this agent.
              '';
            };

            tpm_signing_alg = mkOption {
              type = types.enum [ "rsassa" "rsapss" "ecdsa" "ecdaa" "ecschnorr" ];
              default = "rsassa";
              description = mdDoc '';
                  TPM2-specific options: specify the default signing algorithm to use with a TPM2 for this agent.
              '';
            };

            ek_handle = mkOption {
              type = types.str;
              default = "generate";
              description = mdDoc ''
                  If an EK is already present on the TPM (e.g., with "tpm2_createek") and
                  you require Keylime to use this EK, change "generate" to the actual EK
                  handle (e.g. "0x81000000"). The Keylime agent will then not attempt to
                  create a new EK upon startup, and neither will it flush the EK upon exit.
              '';
            };

            tpm_ownerpassword = mkOption {
              type = types.str;
              default = "";
              description = mdDoc ''
                  Use this option to state the existing TPM ownerpassword.
                  This option should be set only when a password is set for the Endorsement
                  Hierarchy (e.g. via "tpm2_changeauth -c e").
                  If no password was set, keep the empty string "".
              '';
            };

            run_as = mkOption {
              type = types.str;
              default = "keylime:tss";
              description = mdDoc ''
                  The user account to switch to to drop privileges when started as root
                  If left empty, the agent will keep running with high privileges.
                  The user and group specified here must allow the user to access the
                  services.keylime-agent.keylime_dir (by default cfg.keylime_dir) and /dev/tpmrm0.
              '';
            };

            agent_data_path = mkOption {
              type = types.str or types.path;
              default = "default";
              description = mdDoc ''
                  Path where to store the agent tpm data which can be loaded later
                  If not an absolute path, it will be considered a relative path from the
                  directory set by the keylime_dir option above If set as "default" Keylime will
                  use "agent_data.json", located at keylime_dir.
              '';
            };
          };
        };
      };
    };
  };

  config = mkIf cfg.enable {

    environment = {
      etc."keylime/agent.conf".source = configFile;
    };

    systemd.tmpfiles.rules = [
      "d ${cfg.stateDir} 0770 ${cfg.user} ${cfg.group} - -"
      "d ${cfg.stateDir}/cv_ca 0770 ${cfg.user} ${cfg.group} - -"
    ];

    systemd.services.keylime-agent = {
      description = "Keylime configuration filesystem";
      after = [ "network-online.target" "tpm2-abrmd.service" ];
      wantedBy = [ "multi-user.target" ];
      requires = [ "var-lib-keylime-secure.mount" "tpm2-abrmd.service" ];
      unitConfig = {
        StartLimitIntervalSec = 10;
        StartLimitBurst = 5;
      };

      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.rust-keylime}/bin/keylime_agent";
        TimeoutSec = 60;
        Restart = "on-failure";
        RestartSec = 120;
        Environment="RUST_LOG=keylime_agent=info";
      };
    };

    systemd.mounts = [
      {
        description = "Secure mount for keylime-agent";
        what = "tmpfs";
        where = "${cfg.stateDir}/secure";
        type = "tmpfs";
        options = "mode=0700,size=1m,uid=${cfg.user},gid=${cfg.group}";
      }
    ];

    users.users.keylime = {
      description = "Keylime user";
      group = "${cfg.group}";
      isSystemUser = true;
    };

    users.groups.tss = {};
  };
}

