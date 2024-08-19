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

      protocols = lib.options.mkOption {
	default = "plaintext";
	type = lib.types.oneOf [ (lib.types.listOf lib.types.str) (lib.types.str) ];
	description = "Defines the allowed dns protocolss";
      };
      
      ignore_server_list = lib.options.mkOption {
	default = false;
	type = lib.types.bool;
	description = "Ignore cfg.servers if a custom protocols besides plaintext is used";
      };

      relays = lib.options.mkOption {
	default = [ "anon-cs-brazil" ];
	type = lib.types.listOf lib.types.str;
	description = "Which relays to use for anonymous connections";
      };

    };

  config = lib.mkIf cfg.enable {

    networking = {
      enableIPv6 = true;
      useDHCP = false;
      dhcpcd.extraConfig = "nohook resolv.conf";
      networkmanager = {
	enable = true;
	dns = lib.mkIf (cfg.protocols != "plaintext") "none";
      };
    };

    networking.nameservers = 
      if (builtins.elem "plaintext" cfg.protocols) then 
	lib.mkMerge [
	  ( lib.mkIf (builtins.elem "lokinet" cfg.servers) ["127.3.2.1"] )
	  ( lib.mkIf (builtins.elem "quad9" cfg.servers) ["9.9.9.9"] )
	] 
      else 
	[ "127.0.0.1" "::1" ];

    services.dnscrypt-proxy2 = lib.mkIf (
					  builtins.elem "dnscrypt2" cfg.protocols || 
					  builtins.elem "doh" cfg.protocols || 
					  builtins.elem "odoh" cfg.protocols || 
					  builtins.elem "anonymous-dnscrypt2" cfg.protocols
					) {
      enable = true;
      settings = {
	require_dnssec = true;
	require_nolog = true;
	require_nofilter = true;
	dnscrypt_servers = (builtins.elem "dnscrypt2" cfg.protocols || builtins.elem "anonymous-dnscrypt2" cfg.protocols);
      	doh_servers = (builtins.elem "doh" cfg.protocols);
      	odoh_servers = (builtins.elem "odoh" cfg.protocols);
	ipv6_servers = true;
	ignore_system_dns = true;
	listen_addresses = ["127.0.0.1:53" "[::1]:53"];
	http3 = true;

	sources = {
	  public-resolvers = {
	    urls = [
	    "https://raw.githubusercontent.com/DNSCrypt/dnscrypt-resolvers/master/v3/public-resolvers.md"
	    "https://download.dnscrypt.info/resolvers-list/v3/public-resolvers.md"
	    "https://download.dnscrypt.info/dnscrypt-resolvers/v3/opennic.md"
	    ];
	    cache_file = "/var/lib/dnscrypt-proxy2/public-resolvers.md";
	    minisign_key = "RWQf6LRCGA9i53mlYecO4IzT51TGPpvWucNSCh1CBM0QTaLn73Y7GFO3";
	  };

	  relays = {
	    urls = [ 
	      "https://raw.githubusercontent.com/DNSCrypt/dnscrypt-resolvers/master/v3/relays.md" 
	      "https://download.dnscrypt.info/resolvers-list/v3/relays.md" 
	    ];
	    cache_file = "/var/lib/dnscrypt-proxy2/relays.md";
	    minisign_key = "RWQf6LRCGA9i53mlYecO4IzT51TGPpvWucNSCh1CBM0QTaLn73Y7GFO3";
	  };

	  odoh-servers = {
	    urls = [
	      "https://raw.githubusercontent.com/DNSCrypt/dnscrypt-resolvers/master/v3/odoh-servers.md" 
	      "https://download.dnscrypt.info/resolvers-list/v3/odoh-servers.md"
	    ];
	    minisign_key = "RWQf6LRCGA9i53mlYecO4IzT51TGPpvWucNSCh1CBM0QTaLn73Y7GFO3";
	    cache_file = "/var/lib/dnscrypt-proxy2/odoh-servers.md";
	  };

	  odoh-relays = {
	    urls = [
	      "https://raw.githubusercontent.com/DNSCrypt/dnscrypt-resolvers/master/v3/odoh-relays.md"
	      "https://download.dnscrypt.info/resolvers-list/v3/odoh-relays.md"
	    ];
	    minisign_key = "RWQf6LRCGA9i53mlYecO4IzT51TGPpvWucNSCh1CBM0QTaLn73Y7GFO3";
	    cache_file = "/var/lib/dnscrypt-proxy2/odoh-relays.md";
	  };

	};

	anonymized_dns = if (builtins.elem "anonymous-dnscrypt2" cfg.protocols || builtins.elem "odoh" cfg.protocols) then {
	  routes = [
	    { server_name = "*"; via = cfg.relays; }
	    { server_name = "odoh-*"; via = [ "odohrelay-*" ]; }
	  ];
	  skip_incompatible = true;
	} else {};	  


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

    systemd.services.dnscrypt-proxy2.serviceConfig = lib.mkIf (cfg.protocols != "plaintext") {
      StateDirectory = "dnscrypt-proxy";
    };

  };
}
