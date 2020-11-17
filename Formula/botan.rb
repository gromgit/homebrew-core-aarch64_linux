class Botan < Formula
  desc "Cryptographic algorithms and formats library in C++"
  homepage "https://botan.randombit.net/"
  url "https://botan.randombit.net/releases/Botan-2.17.2.tar.xz"
  sha256 "ebe27dfe2b55d7e02bf520e926606c48b76b22facb483256b13ab38e018e1e6c"
  license "BSD-2-Clause"
  head "https://github.com/randombit/botan.git"

  bottle do
    sha256 "11a42d9309a1fc2c48abd23d66d68783226ebf5b6306332a5fd7d3499878e2de" => :big_sur
    sha256 "f922534635d6435cd99fd3ad9125f73dd5fba9f11e0fd1f2c71212663ae17518" => :catalina
    sha256 "7b3d9f8e516b601561dd465184b7a7e7cc3b0d87d642f9e1fbf7805dbb0677b3" => :mojave
    sha256 "ff01010ef50266f76310d2219a5266d5cb0b877af342e327e3a2c749b9967da1" => :high_sierra
  end

  depends_on "pkg-config" => :build
  depends_on "python@3.9"
  depends_on "sqlite"

  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  def install
    ENV.cxx11

    args = %W[
      --prefix=#{prefix}
      --docdir=share/doc
      --cc=#{ENV.compiler}
      --os=darwin
      --with-zlib
      --with-bzip2
      --with-sqlite3
      --with-python-versions=3.9
    ]

    system "./configure.py", *args
    system "make", "install"
  end

  test do
    (testpath/"test.txt").write "Homebrew"
    (testpath/"testout.txt").write shell_output("#{bin}/botan base64_enc test.txt")
    assert_match "Homebrew", shell_output("#{bin}/botan base64_dec testout.txt")
  end
end
