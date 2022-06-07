class Libnatpmp < Formula
  desc "NAT port mapping protocol library"
  homepage "http://miniupnp.free.fr/libnatpmp.html"
  url "http://miniupnp.free.fr/files/download.php?file=libnatpmp-20150609.tar.gz"
  sha256 "e1aa9c4c4219bc06943d6b2130f664daee213fb262fcb94dd355815b8f4536b0"

  livecheck do
    url "http://miniupnp.free.fr/files/"
    regex(/href=.*?libnatpmp[._-]v?(\d{6,8})\.t/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/libnatpmp"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "e93d337722343bebfffecc2ff01b4a2029837e6106b936ecda6c5976268032a0"
  end

  def install
    # Reported upstream:
    # https://miniupnp.tuxfamily.org/forum/viewtopic.php?t=978
    inreplace "Makefile", "-Wl,-install_name,$(SONAME)", "-Wl,-install_name,$(INSTALLDIRLIB)/$(SONAME)"
    system "make", "INSTALLPREFIX=#{prefix}", "install"
  end
end
