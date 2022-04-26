{ lib, buildGo118Package, src, version, qemu_kvm }:

buildGo118Package rec {
  pname = "virtiofsd";
  inherit version src;

  goPackagePath = "gitlab.com/virtio-fs/virtiofsd";

  buildCommand = ''
    mkdir -p $out/bin
    cd ${qemu_kvm}
    cd ../
    ln -s ./libexec/virtiofsd $out/bin/
    ln -s ./libexec/virtfs-proxy-helper $out/bin/
    export PATH=$out/bin:$PATH
  '';
  
  meta = with lib; {
    description = "Virtiofsd allowing LXD to use virtfs-proxy-helper";
    homepage = "https://gitlab.com/virtio-fs/virtiofsd";
    maintainers = with maintainers; [ kellianoy ];
    platforms = platforms.linux;
  };       
}