class Gloox < Formula
  desc "C++ Jabber/XMPP library that handles the low-level protocol"
  homepage "https://camaya.net/gloox/"
  url "https://camaya.net/download/gloox-1.0.24.tar.bz2"
  sha256 "ae1462be2a2eb8fe5cd054825143617c53c2c9c7195606cb5a5ba68c0f68f9c9"

  livecheck do
    url :homepage
    regex(/Latest stable version.*?href=.*?gloox[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/gloox"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "b2f2588f53eaee4432ae8ed001599175eddf8032b651fce33e7f04660545e274"
  end

  depends_on "pkg-config" => :build
  depends_on "libidn"
  depends_on "openssl@1.1"

  uses_from_macos "zlib"

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--with-zlib",
                          "--disable-debug",
                          "--with-openssl=#{Formula["openssl@1.1"].opt_prefix}"
    system "make", "install"
  end

  test do
    system bin/"gloox-config", "--cflags", "--libs", "--version"
  end
end
