class Mcabber < Formula
  desc "Console Jabber client"
  homepage "https://mcabber.com/"
  url "https://mcabber.com/files/mcabber-1.1.2.tar.bz2"
  sha256 "c4a1413be37434b6ba7d577d94afb362ce89e2dc5c6384b4fa55c3e7992a3160"
  license "GPL-2.0-or-later"

  bottle do
    sha256 "ee47a9acdd7772e85f13479db1306c612a4a3da1695fba50d10c2f769a43305a" => :catalina
    sha256 "922acf4fa2a52e1bac0156099357081a779c875a7d7f05d04343b13d555c2d8a" => :mojave
    sha256 "1c988edd8a478dfb42532470a455b3c5c81f41186186683e77793e0d881c4153" => :high_sierra
  end

  head do
    url "https://mcabber.com/hg/", using: :hg

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "gpgme"
  depends_on "libgcrypt"
  depends_on "libidn"
  depends_on "libotr"
  depends_on "loudmouth"

  def install
    if build.head?
      cd "mcabber"
      inreplace "autogen.sh", "libtoolize", "glibtoolize"
      system "./autogen.sh"
    end

    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-otr"
    system "make", "install"

    pkgshare.install %w[mcabberrc.example contrib]
  end

  def caveats
    <<~EOS
      A configuration file is necessary to start mcabber.  The template is here:
        #{opt_pkgshare}/mcabberrc.example
      And there is a Getting Started Guide you will need to setup Mcabber:
        https://wiki.mcabber.com/#index2h1
    EOS
  end

  test do
    system "#{bin}/mcabber", "-V"
  end
end
