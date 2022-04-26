{ lib, buildGo118Package, src, version, qemu_kvm }:

buildGo118Package rec {
  pname = "virtiofsd";
  inherit version src;

  goPackagePath = "gitlab.com/virtio-fs/virtiofsd";

  buildCommand = ''
    mkdir -p $out/bin
    ln -s ${qemu_kvm}/libexec/virtiofsd $out/bin/
    ln -s ${qemu_kvm}/libexec/virtfs-proxy-helper $out/bin/
  '';
  
  meta = with lib; {
    description = "Virtiofsd allowing LXD to use virtfs-proxy-helper";
    homepage = "https://gitlab.com/virtio-fs/virtiofsd";
    maintainers = with maintainers; [ kellianoy ];
    platforms = platforms.linux;
  };       
}