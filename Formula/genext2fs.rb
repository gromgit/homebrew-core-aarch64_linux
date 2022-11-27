class Genext2fs < Formula
  desc "Generates an ext2 filesystem as a normal (non-root) user"
  homepage "https://genext2fs.sourceforge.io/"
  url "https://github.com/bestouff/genext2fs/archive/refs/tags/v1.5.0.tar.gz"
  sha256 "d3861e4fe89131bd21fbd25cf0b683b727b5c030c4c336fadcd738ada830aab0"
  license "GPL-2.0-or-later"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/genext2fs"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "99a8ad8e3a592bac68292db7642104cae20646cc2a01b04c26a9f317329e21c2"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build

  def install
    system "./autogen.sh"
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    rootpath = testpath/"img"
    (rootpath/"foo.txt").write "hello world"
    system "#{bin}/genext2fs", "--root", rootpath,
                               "--block-size", "4096",
                               "--size-in-blocks", "100",
                               "#{testpath}/test.img"
  end
end
