class Gsasl < Formula
  desc "SASL library command-line interface"
  homepage "https://www.gnu.org/software/gsasl/"
  url "https://ftp.gnu.org/gnu/gsasl/gsasl-2.2.0.tar.gz"
  mirror "https://ftpmirror.gnu.org/gsasl/gsasl-2.2.0.tar.gz"
  sha256 "79b868e3b9976dc484d59b29ca0ae8897be96ce4d36d32aed5d935a7a3307759"
  license "GPL-3.0-or-later"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/gsasl"
    sha256 aarch64_linux: "56b21ce9a9398b183ae4971c99c0bd457fd0f5d821093e30d4f3d38ac124c85f"
  end

  depends_on "libgcrypt"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--with-gssapi-impl=mit",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gsasl --version")
  end
end
