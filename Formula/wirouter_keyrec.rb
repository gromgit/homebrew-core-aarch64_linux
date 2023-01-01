class WirouterKeyrec < Formula
  desc "Recover the default WPA passphrases from supported routers"
  homepage "https://www.salvatorefresta.net/tools/"
  url "https://www.mirrorservice.org/sites/distfiles.macports.org/wirouterkeyrec/WiRouter_KeyRec_1.1.2.zip"
  mirror "https://distfiles.macports.org/wirouterkeyrec/WiRouter_KeyRec_1.1.2.zip"
  sha256 "3e59138f35502b32b47bd91fe18c0c232921c08d32525a2ae3c14daec09058d4"
  license "GPL-3.0"

  livecheck do
    url :homepage
    regex(%r{href=.*?/WiRouter_KeyRec[._-]v?(\d+(?:\.\d+)+)\.zip}i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/wirouter_keyrec"
    sha256 aarch64_linux: "5d347d7a97e486ec1db3068504549ee2185d6c5e222ce51b2c76d4e3da3224fb"
  end

  def install
    inreplace "src/agpf.h", %r{/etc}, "#{prefix}/etc"
    inreplace "src/teletu.h", %r{/etc}, "#{prefix}/etc"

    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--sysconfdir=#{prefix}",
                          "--exec-prefix=#{prefix}"
    system "make", "prefix=#{prefix}"
    system "make", "install", "DESTDIR=#{prefix}", "BIN_DIR=bin/"
  end

  test do
    system "#{bin}/wirouterkeyrec", "-s", "Alice-12345678"
  end
end
