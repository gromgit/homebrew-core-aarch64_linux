class Sslscan < Formula
  desc "Test SSL/TLS enabled services to discover supported cipher suites"
  homepage "https://github.com/rbsec/sslscan"
  url "https://github.com/rbsec/sslscan/archive/2.0.2.tar.gz"
  sha256 "9996dec2f4b6d20f1ba6411f157f3163389c52ae8d5e98528aeb0ea3d8b06cd1"
  license "GPL-3.0-or-later"
  head "https://github.com/rbsec/sslscan.git"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)(?:-rbsec)?$/i)
  end

  bottle do
    cellar :any
    sha256 "c1fad47864adc523961d3116312124a89c95b66f0f12c3ad2bfab68c8d41f5f1" => :catalina
    sha256 "703cfebce6d66dc36d0f019b1feed8ce988d11b74453350123dd955bb6ee0cbe" => :mojave
    sha256 "0a9e4699f5604e6f13b6f56d728198b2fd17c0d32e84a30c9c03faae8f0c125f" => :high_sierra
  end

  depends_on "openssl@1.1"

  def install
    # use `libcrypto.dylib` built from `openssl@1.1`
    inreplace "Makefile", "static: openssl/libcrypto.a",
                          "static: #{Formula["openssl@1.1"].opt_lib}/libcrypto.dylib"

    system "make", "static"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    assert_match "static", shell_output("#{bin}/sslscan --version")
    system "#{bin}/sslscan", "google.com"
  end
end
