class Htop < Formula
  desc "Improved top (interactive process viewer)"
  homepage "https://htop.dev/"
  url "https://github.com/htop-dev/htop/archive/3.0.0.tar.gz"
  sha256 "1c0661f0ae5f4e2874da250b60cd515e4ac4c041583221adfe95f10e18d1a4e6"
  license "GPL-2.0-or-later"
  head "https://github.com/htop-dev/htop.git"

  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    cellar :any
    sha256 "f53ae5c8d846b7f11ef6431f65b1a056a31d2703c1b2bc691330cd618dea5a3a" => :catalina
    sha256 "7007e92a3c9b4f818c9caa53ac27b941b3b6079d5eff62f84837d5092d04ea83" => :mojave
    sha256 "db64171160ccd3abce6be5fad7547aa254fa0b46b6447b37a08a3a31c5e1f66a" => :high_sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "ncurses" # enables mouse scroll

  def install
    system "./autogen.sh"
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  def caveats
    <<~EOS
      htop requires root privileges to correctly display all running processes,
      so you will need to run `sudo htop`.
      You should be certain that you trust any software you grant root privileges.
    EOS
  end

  test do
    pipe_output("#{bin}/htop", "q", 0)
  end
end
