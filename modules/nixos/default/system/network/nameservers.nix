{ config, lib, pkgs, ... }:

  let
    cfg = config.nixosModules.default.system.network.nameservers;
  in {

    options.nixosModules.default.system.network.nameservers = {

      enable = lib.options.mkEnableOption {
	default = false;
	type = lib.types.bool;
	description = "Configures dns stuff";
      };

      servers = lib.options.mkOption {
	default = [ "quad9" ];
	type = lib.types.listOf lib.types.str;
	description = "Select the servers to add";
      };

      protocol = lib.options.mkOption {
	default = "plaintext";
	type = lib.types.str;
	description = "Define dns protocol";
      };

      ignore_server_list = lib.options.mkOption {
	default = false;
	type = lib.types.bool;
	description = "Ignore cfg.servers if a custom protocol besides plaintext is used";
      };

    };

  config = lib.mkIf cfg.enable {

    networking = {
      enableIPv6 = true;
      useDHCP = false;
      dhcpcd.extraConfig = "nohook resolv.conf";
      networkmanager = {
	enable = true;
	dns = lib.mkIf (cfg.protocol != "plaintext") "none";
      };
    };

    networking.nameservers = 
      if cfg.protocol == "plaintext" then 
	lib.mkMerge [
	  ( lib.mkIf (builtins.elem "lokinet" cfg.servers) ["127.3.2.1"] )
	  ( lib.mkIf (builtins.elem "quad9" cfg.servers) ["9.9.9.9"] )
	] 
      else 
	[ "127.0.0.1" "::1" ];

    services.dnscrypt-proxy2 = lib.mkIf (cfg.protocol == "dnscrypt2") {
      enable = true;
      settings = {
	require_dnssec = true;
	require_nolog = true;
	require_nofilter = true;
      	ipv6_servers = true;
	ignore_system_dns = true;
	listen_addresses = ["127.0.0.1:53" "[::1]:53"];

	sources.public-resolvers = {
	  urls = [
	    "https://raw.githubusercontent.com/DNSCrypt/dnscrypt-resolvers/master/v3/public-resolvers.md"
	    "https://download.dnscrypt.info/resolvers-list/v3/public-resolvers.md"
	  ];
	  cache_file = "/var/lib/dnscrypt-proxy2/public-resolvers.md";
	  minisign_key = "RWQf6LRCGA9i53mlYecO4IzT51TGPpvWucNSCh1CBM0QTaLn73Y7GFO3";
	};

	server_names = if cfg.ignore_server_list == false then [
	  ( if (builtins.elem "quad9" cfg.servers) then "quad9-dnscrypt-ip4-nofilter-ecs-pri" else "" )
	  ( if (builtins.elem "opennic" cfg.servers) then "opennic1_kekew_info_ipv4" else "" )
	  ( if (builtins.elem "opennic" cfg.servers) then "opennic1_kekew_info_ipv6" else "" )
	  ( if (builtins.elem "opennic" cfg.servers) then "opennic2_kekew_info_ipv4" else "" )
	  ( if (builtins.elem "opennic" cfg.servers) then "opennic3_kekew_info_ipv4" else "" )
	] else [];

	static = if cfg.ignore_server_list == false then {
	  opennic1_kekew_info_ipv4 = { stamp = if (builtins.elem "opennic" cfg.servers) then "sdns://AQcAAAAAAAAAEDEwOS45MS4xODQuMjE6NTQgkuaRfQrPuzkvgT0_YGI_k5veCS_7H3cT4_Y3sgmop3oaMi5kbnNjcnlwdC1jZXJ0Lmtla2V3LmluZm8" else ""; };
	  opennic1_kekew_info_ipv6 = { stamp = if (builtins.elem "opennic" cfg.servers) then "sdns://AQcAAAAAAAAAF1syMDAzOmE6NjRiOjNiMDA6OjhdOjU0IJLmkX0Kz7s5L4E9P2BiP5Ob3gkv-x93E-P2N7IJqKd6GjIuZG5zY3J5cHQtY2VydC5rZWtldy5pbmZv" else ""; };
	  opennic2_kekew_info_ipv4 = { stamp = if (builtins.elem "opennic" cfg.servers) then "sdns://AQcAAAAAAAAAETgwLjE1Mi4yMDMuMTM0OjU0IPNqicy0t-MhnuiOf1kb4b42I1dkOyqw3NQ9VWhjjkbwGjIuZG5zY3J5cHQtY2VydC5rZWtldy5pbmZv" else ""; };
	  opennic3_kekew_info_ipv4 = { stamp = if (builtins.elem "opennic" cfg.servers) then "sdns://AQcAAAAAAAAAF1syMDAzOmE6NjRiOjNiMDA6OjRdOjU0IP3tgRfQXIUOXFhC71k6nRR2G_bOr88lwFkjtO-iVgJOGjIuZG5zY3J5cHQtY2VydC5rZWtldy5pbmZv" else ""; };
	} else {};
      };
    };

    systemd.services.dnscrypt-proxy2.serviceConfig = lib.mkIf (cfg.protocol != "plaintext") {
      StateDirectory = "dnscrypt-proxy";
    };

  };
}
