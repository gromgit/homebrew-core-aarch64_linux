class Byobu < Formula
  desc "Text-based window manager and terminal multiplexer"
  homepage "https://launchpad.net/byobu"
  url "https://launchpad.net/byobu/trunk/5.131/+download/byobu_5.131.orig.tar.gz"
  sha256 "77ac751ae79d8e3f0377ac64b64bc9738fa68d68466b8d2ff652b63b1d985e52"

  bottle do
    cellar :any_skip_relocation
    sha256 "07b9d980d33ff5c4cccc2f9ff70b17c88e97a1a34d8a43bfba1378f4ad8981a8" => :catalina
    sha256 "07b9d980d33ff5c4cccc2f9ff70b17c88e97a1a34d8a43bfba1378f4ad8981a8" => :mojave
    sha256 "07b9d980d33ff5c4cccc2f9ff70b17c88e97a1a34d8a43bfba1378f4ad8981a8" => :high_sierra
  end

  head do
    url "https://github.com/dustinkirkland/byobu.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on "coreutils"
  depends_on "gnu-sed" # fails with BSD sed
  depends_on "newt"
  depends_on "tmux"

  conflicts_with "ctail", :because => "both install `ctail` binaries"

  def install
    if build.head?
      cp "./debian/changelog", "./ChangeLog"
      system "autoreconf", "-fvi"
    end
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  def caveats; <<~EOS
    Add the following to your shell configuration file:
      export BYOBU_PREFIX=#{HOMEBREW_PREFIX}
  EOS
  end

  test do
    system bin/"byobu-status"
  end
end
