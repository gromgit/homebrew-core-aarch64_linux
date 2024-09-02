class Rgxg < Formula
  desc "C library and command-line tool to generate (extended) regular expressions"
  homepage "https://rgxg.github.io"
  url "https://github.com/rgxg/rgxg/releases/download/v0.1.2/rgxg-0.1.2.tar.gz"
  sha256 "554741f95dcc320459875c248e2cc347b99f809d9555c957d763d3d844e917c6"
  license "Zlib"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/rgxg"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "8ff69e9c8db8f7382998c84dd543c614e14db5a67bb7a1549a7499d328669a77"
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system bin/"rgxg", "range", "1", "10"
  end
end
