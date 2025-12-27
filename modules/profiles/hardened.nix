# A profile with most (vanilla) hardening options enabled by default,
# potentially at the cost of stability, features and performance.
#
# This profile enables options that are known to affect system
# stability. If you experience any stability issues when using the
# profile, try disabling it. If you report an issue and use this
# profile, always mention that you do.

{ config, lib, pkgs, ... }:

with lib;

{
  # meta = {
  #   maintainers = [ maintainers.joachifm maintainers.emily ];
  # };


  nix.settings.allowed-users = mkDefault [ "@users" ];

  environment = {
    memoryAllocator.provider = mkDefault "scudo";
    variables.SCUDO_OPTIONS = mkDefault "ZeroContents=1";
  };


  security = {
    lockKernelModules = mkDefault true;
    protectKernelImage = mkDefault true;
    allowSimultaneousMultithreading = mkDefault false;
    forcePageTableIsolation = mkDefault true;
    # This is required by podman to run containers in rootless mode.
    unprivilegedUsernsClone = mkDefault config.virtualisation.containers.enable;
    virtualisation.flushL1DataCache = mkDefault "always";
    apparmor = {
      enable = mkDefault true;
      killUnconfinedConfinables = mkDefault true;
    };
  };

  boot = {
    kernelPackages = mkDefault pkgs.linuxPackages_hardened;

    kernelParams = [
      # Slab/slub sanity checks, redzoning, and poisoning
      "slub_debug=FZP"

      # Overwrite free'd memory
      "page_poison=1"

      # Enable page allocator randomization
      "page_alloc.shuffle=1"
    ];

    blacklistedKernelModules = [
      # Obscure network protocols
      "ax25"
      "netrom"
      "rose"

      # Old or rare or insufficiently audited filesystems
      "adfs"
      "affs"
      "bfs"
      "befs"
      "cramfs"
      "efs"
      "erofs"
      "exofs"
      "freevxfs"
      "f2fs"
      "hfs"
      "hpfs"
      "jfs"
      "minix"
      "nilfs2"
      "ntfs"
      "omfs"
      "qnx4"
      "qnx6"
      "sysv"
      "ufs"
    ];

    kernel.sysctl = {
      # Restrict ptrace() usage to processes with a pre-defined relationship
      # (e.g., parent/child)
      "kernel.yama.ptrace_scope" = mkOverride 500 1;

      # Hide kptrs even for processes with CAP_SYSLOG
      "kernel.kptr_restrict" = mkOverride 500 2;

      # Disable bpf() JIT (to eliminate spray attacks)
      "net.core.bpf_jit_enable" = mkDefault false;

      # Disable ftrace debugging
      "kernel.ftrace_enabled" = mkDefault false;

      # Enable strict reverse path filtering (that is, do not attempt to route
      # packets that "obviously" do not belong to the iface's network; dropped
      # packets are logged as martians).
      "net.ipv4.conf.all.log_martians" = mkDefault true;
      "net.ipv4.conf.all.rp_filter" = mkDefault "1";
      "net.ipv4.conf.default.log_martians" = mkDefault true;
      "net.ipv4.conf.default.rp_filter" = mkDefault "1";

      # Ignore broadcast ICMP (mitigate SMURF)
      "net.ipv4.icmp_echo_ignore_broadcasts" = mkDefault true;

      # Ignore incoming ICMP redirects (note: default is needed to ensure that the
      # setting is applied to interfaces added after the sysctls are set)
      "net.ipv4.conf.all.accept_redirects" = mkDefault false;
      "net.ipv4.conf.all.secure_redirects" = mkDefault false;
      "net.ipv4.conf.default.accept_redirects" = mkDefault false;
      "net.ipv4.conf.default.secure_redirects" = mkDefault false;
      "net.ipv6.conf.all.accept_redirects" = mkDefault false;
      "net.ipv6.conf.default.accept_redirects" = mkDefault false;

      # Ignore outgoing ICMP redirects (this is ipv4 only)
      "net.ipv4.conf.all.send_redirects" = mkDefault false;
      "net.ipv4.conf.default.send_redirects" = mkDefault false;
    };
  };

  # disable coredump that could be exploited later
  # and also slow down the system when something crash
  systemd.coredump.enable = false;

  # to avoid logrotate failure https://discourse.nixos.org/t/logrotate-config-fails-due-to-missing-group-30000/28501/5
  services.logrotate.checkConfig = false;
}
