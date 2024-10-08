class Mandoc < Formula
  desc "UNIX manpage compiler toolset"
  homepage "https://mandoc.bsd.lv/"
  url "https://mandoc.bsd.lv/snapshots/mandoc-1.14.6.tar.gz"
  sha256 "8bf0d570f01e70a6e124884088870cbed7537f36328d512909eb10cd53179d9c"
  license "ISC"
  revision 1
  head "anoncvs@mandoc.bsd.lv:/cvs", using: :cvs

  livecheck do
    url "https://mandoc.bsd.lv/snapshots/"
    regex(/href=.*?mandoc[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/mandoc-1.14.6"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "ffd5ecbc5673d6a71262d4c61ce14212546031a198414b11269a6262e0a41fc0"
  end

  uses_from_macos "zlib"

  def install
    localconfig = [

      # Sane prefixes.
      "PREFIX=#{prefix}",
      "INCLUDEDIR=#{include}",
      "LIBDIR=#{lib}",
      "MANDIR=#{man}",
      "WWWPREFIX=#{prefix}/var/www",
      "EXAMPLEDIR=#{share}/examples",

      # Executable names, where utilities would be replaced/duplicated.
      # The mandoc versions of the utilities are definitely *not* ready
      # for prime-time on Darwin, though some changes in HEAD are promising.
      # The "bsd" prefix (like bsdtar, bsdmake) is more informative than "m".
      "BINM_MAN=bsdman",
      "BINM_APROPOS=bsdapropos",
      "BINM_WHATIS=bsdwhatis",
      "BINM_MAKEWHATIS=bsdmakewhatis", # default is "makewhatis".
      "BINM_SOELIM=bsdsoelim", # conflicts with groff's soelim

      # These are names for *section 7* pages only. Several other pages are
      # prefixed "mandoc_", similar to the "groff_" pages.
      "MANM_MAN=man",
      "MANM_MDOC=mdoc",
      "MANM_ROFF=mandoc_roff", # This is the only one that conflicts (groff).
      "MANM_EQN=eqn",
      "MANM_TBL=tbl",

      # Not quite sure what to do here. The default ("/usr/share", etc.) needs
      # sudoer privileges, or will error. So just brew's manpages for now?
      "MANPATH_DEFAULT=#{HOMEBREW_PREFIX}/share/man",

      "HAVE_MANPATH=0",   # Our `manpath` is a symlink to system `man`.
      "STATIC=",          # No static linking on Darwin.

      "HOMEBREWDIR=#{HOMEBREW_CELLAR}", # ? See configure.local.example, NEWS.
      "BUILD_CGI=1",
    ]

    # Bottom corner signature line.
    localconfig << if OS.mac?
      "OSNAME='macOS #{MacOS.version}'"
    else
      "OSNAME='Linux'"
    end

    File.rename("cgi.h.example", "cgi.h") # For man.cgi

    (buildpath/"configure.local").write localconfig.join("\n")
    system "./configure"

    # I've tried twice to send a bug report on this to tech@mdocml.bsd.lv.
    # In theory, it should show up with:
    # search.gmane.org/?query=jobserver&group=gmane.comp.tools.mdocml.devel
    ENV.deparallelize do
      system "make"
      system "make", "install"
    end
  end

  test do
    system bin/"mandoc", "-Thtml",
      "-Ostyle=#{share}/examples/example.style.css", "#{man1}/mandoc.1"
  end
end
