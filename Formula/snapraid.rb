class Snapraid < Formula
  desc "Backup program for disk arrays"
  homepage "https://www.snapraid.it/"
  url "https://github.com/amadvance/snapraid/releases/download/v12.1/snapraid-12.1.tar.gz"
  sha256 "49337d9bafa96c2beac0125463bd22622be2fc00f3b4dee7e4b0e864d2a49661"
  license "GPL-3.0"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/snapraid"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "25c7d66ef3d71cba9b0f2c56f1deca56120f02a85ac26a33c0284f7c58e8ad7d"
  end

  head do
    url "https://github.com/amadvance/snapraid.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/snapraid --version")
  end
end
