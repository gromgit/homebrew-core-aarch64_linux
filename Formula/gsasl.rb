class Gsasl < Formula
  desc "SASL library command-line interface"
  homepage "https://www.gnu.org/software/gsasl/"
  url "https://ftp.gnu.org/gnu/gsasl/gsasl-1.10.0.tar.gz"
  mirror "https://ftpmirror.gnu.org/gsasl/gsasl-1.10.0.tar.gz"
  sha256 "85bcbd8ee6095ade7870263a28ebcb8832f541ea7393975494926015c07568d3"
  license "GPL-3.0-or-later"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/gsasl"
    sha256 aarch64_linux: "808f9aa626d8fbde34ffc35031534f14a588267a61ab969a9e301e3c4b6dbc1c"
  end

  depends_on "libgcrypt"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--with-gssapi-impl=mit",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gsasl")
  end
end
