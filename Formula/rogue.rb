class Rogue < Formula
  desc "Dungeon crawling video game"
  # Historical homepage: https://web.archive.org/web/20160604020207/rogue.rogueforge.net/
  homepage "https://sourceforge.net/projects/roguelike/"
  url "https://src.fedoraproject.org/repo/pkgs/rogue/rogue5.4.4-src.tar.gz/033288f46444b06814c81ea69d96e075/rogue5.4.4-src.tar.gz"
  sha256 "7d37a61fc098bda0e6fac30799da347294067e8e079e4b40d6c781468e08e8a1"

  livecheck do
    url "https://src.fedoraproject.org/repo/pkgs/rogue/"
    regex(/href=.*?rogue-?v?(\d+(?:\.\d+)+)(?:-src)?\.t/i)
  end

  bottle do
    cellar :any_skip_relocation
    rebuild 2
    sha256 "c6e8bb630a966cd8885e378242f9175ffd8327e26ec1ed679016302b437a5156" => :big_sur
    sha256 "1cfeb02e30c14d89cf9d831c553a06eb17a6d6d27734c215e3ee7e72ab0c7c76" => :arm64_big_sur
    sha256 "c576555f6857ff3ec7f0b2e39625d3c1f86989315b735a5e27d9416c095e5efc" => :catalina
    sha256 "7a7a380bb29967b8e795aa2407e8f205752b93952082491e20fff84394819294" => :mojave
  end

  def install
    # Fix main.c:241:11: error: incomplete definition of type 'struct _win_st'
    ENV.append "CPPFLAGS", "-DNCURSES_OPAQUE=0"

    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"

    inreplace "config.h", "rogue.scr", "#{var}/rogue/rogue.scr"

    inreplace "Makefile" do |s|
      # Take out weird man install script and DIY below
      s.gsub! "-if test -d $(man6dir) ; then $(INSTALL) -m 0644 rogue.6 $(DESTDIR)$(man6dir)/$(PROGRAM).6 ; fi", ""
      s.gsub! "-if test ! -d $(man6dir) ; then $(INSTALL) -m 0644 rogue.6 $(DESTDIR)$(mandir)/$(PROGRAM).6 ; fi", ""
    end

    system "make", "install"
    man6.install gzip("rogue.6")
    libexec.mkpath
    (var/"rogue").mkpath
  end

  test do
    system "#{bin}/rogue", "-s"
  end
end
