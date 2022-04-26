{ lib, linkFarm, fetchurl, callPackage, qemu_kvm, qemu-utils, OVMFFull, bash
, installShellFiles, useQemu ? false, version ? "5.0.0" }:

let

  src = fetchurl {
    url = "https://linuxcontainers.org/downloads/lxd/lxd-${version}.tar.gz";
    sha256 = "sha256-qZt+37UsgZWy3kmIhE0y1zvmQm9s/yhAglBReyOP3vk=";
  };

  lxd-agent = callPackage ./lxd-agent.nix {
    inherit src version;
  };

  firmware = linkFarm "lxd-firmware" [
    {
      name = "share/OVMF/OVMF_CODE.fd";
      path = "${OVMFFull.fd}/FV/OVMF_CODE.fd";
    }
    {
      name = "share/OVMF/OVMF_VARS.fd";
      path = "${OVMFFull.fd}/FV/OVMF_VARS.fd";
    }
    {
      name = "share/OVMF/OVMF_VARS.ms.fd";
      path = "${OVMFFull.fd}/FV/OVMF_VARS.fd";
    }
  ];

in
  callPackage ./lxd.nix {
    inherit src version;
    extraBinPath = lib.optionals useQemu [ qemu-utils qemu_kvm lxd-agent];
    LXD_OVMF_PATH = lib.optionalString useQemu "${firmware}/share/OVMF";
  }

