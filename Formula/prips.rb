class Prips < Formula
  desc "Print the IP addresses in a given range"
  homepage "https://devel.ringlet.net/sysutils/prips/"
  url "https://devel.ringlet.net/files/sys/prips/prips-1.2.0.tar.xz"
  sha256 "de28d8a5a619a30d0b3c8a76f9c09c3529d197f3e74b04c8aa994096ab8349d4"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/current version .*?prips.*?v?(\d+(?:\.\d+)+)/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/prips"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "46eb827a01507c1a64fdd562d74a5b8e963140d579cf0ca9dba8070547b59ed8"
  end

  def install
    system "make"
    bin.install "prips"
    man1.install "prips.1"
  end

  test do
    assert_equal "127.0.0.0\n127.0.0.1",
      shell_output("#{bin}/prips 127.0.0.0/31").strip
  end
end
