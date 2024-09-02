class Flake < Formula
  desc "FLAC audio encoder"
  homepage "https://flake-enc.sourceforge.io"
  url "https://downloads.sourceforge.net/project/flake-enc/flake/0.11/flake-0.11.tar.bz2"
  sha256 "8dd249888005c2949cb4564f02b6badb34b2a0f408a7ec7ab01e11ceca1b7f19"
  license "LGPL-2.1"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/flake"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "09e817fcdd32e625a608e340a087fc5d1722e0bf22084803811b4be2c3b1be6f"
  end

  def install
    ENV.deparallelize
    system "./configure", "--disable-debug", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    system bin/"flake", test_fixtures("test.wav"), "-o", testpath/"test"
  end
end
