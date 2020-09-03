class Htop < Formula
  desc "Improved top (interactive process viewer)"
  homepage "https://htop.dev/"
  url "https://github.com/htop-dev/htop/archive/3.0.1.tar.gz"
  sha256 "8465164bc085f5f1813e1d3f6c4b9b56bf4c95cc12226a5367e65794949b01ca"
  license "GPL-2.0-or-later"
  head "https://github.com/htop-dev/htop.git"

  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    cellar :any
    sha256 "82587d9e03beca35d06e7e82225c021d4af07ecfe9d901d867cfeebec8edbb6d" => :catalina
    sha256 "c9ce09b9aee0b84c5837122ad84482536383752332366495b9021510c2b94474" => :mojave
    sha256 "0d2fe8465f89d94a1e95a7b625387f4830e1d4c90c2bb3f8f58818a413c251e6" => :high_sierra
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
