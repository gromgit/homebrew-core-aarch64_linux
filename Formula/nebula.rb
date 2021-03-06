class Nebula < Formula
  desc "Scalable overlay networking tool for connecting computers anywhere"
  homepage "https://github.com/slackhq/nebula"
  url "https://github.com/slackhq/nebula/archive/v1.5.2.tar.gz"
  sha256 "391ac38161561690a65c0fa5ad65a2efb2d187323cc8ee84caa95fa24cb6c36a"
  license "MIT"
  revision 1

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/nebula"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "3599104942b5cdbbbb8f662e3e6529a6faca79674d29f3eb4ee2c1933e6a44a1"
  end

  depends_on "go" => :build

  def install
    ENV["BUILD_NUMBER"] = version
    system "make", "service"
    bin.install "./nebula"
    bin.install "./nebula-cert"
    prefix.install_metafiles
  end

  plist_options startup: true
  service do
    run [opt_bin/"nebula", "-config", etc/"nebula/config.yml"]
    keep_alive true
    log_path var/"log/nebula.log"
    error_log_path var/"log/nebula.log"
  end

  test do
    system "#{bin}/nebula-cert", "ca", "-name", "testorg"
    system "#{bin}/nebula-cert", "sign", "-name", "host", "-ip", "192.168.100.1/24"
    (testpath/"config.yml").write <<~EOS
      pki:
        ca: #{testpath}/ca.crt
        cert: #{testpath}/host.crt
        key: #{testpath}/host.key
    EOS
    system "#{bin}/nebula", "-test", "-config", "config.yml"
  end
end
