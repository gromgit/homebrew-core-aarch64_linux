class Guile < Formula
  desc "GNU Ubiquitous Intelligent Language for Extensions"
  homepage "https://www.gnu.org/software/guile/"
  url "https://ftp.gnu.org/gnu/guile/guile-3.0.8.tar.xz"
  mirror "https://ftpmirror.gnu.org/guile/guile-3.0.8.tar.xz"
  sha256 "daa7060a56f2804e9b74c8d7e7fe8beed12b43aab2789a38585183fcc17b8a13"
  license "LGPL-3.0-or-later"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/guile"
    sha256 aarch64_linux: "ec3de377b5fd05c39107e978bc480e6add14162d814840dd811598ffa05c3ab6"
  end


  head do
    url "https://git.savannah.gnu.org/git/guile.git", branch: "main"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "gettext" => :build
    uses_from_macos "flex" => :build
  end

  depends_on "gnu-sed" => :build
  depends_on "bdw-gc"
  depends_on "gmp"
  depends_on "libffi"
  depends_on "libtool"
  depends_on "libunistring"
  depends_on "pkg-config" # guile-config is a wrapper around pkg-config.
  depends_on "readline"

  uses_from_macos "gperf"

  def install
    # Avoid superenv shim
    inreplace "meta/guile-config.in", "@PKG_CONFIG@", Formula["pkg-config"].opt_bin/"pkg-config"

    system "./autogen.sh" unless build.stable?

    # Disable JIT on Apple Silicon, as it is not yet supported
    # https://debbugs.gnu.org/cgi/bugreport.cgi?bug=44505
    extra_args = []
    extra_args << "--enable-jit=no" if Hardware::CPU.arm?

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-libreadline-prefix=#{Formula["readline"].opt_prefix}",
                          "--with-libgmp-prefix=#{Formula["gmp"].opt_prefix}",
                          *extra_args
    system "make", "install"

    # A really messed up workaround required on macOS --mkhl
    Pathname.glob("#{lib}/*.dylib") do |dylib|
      lib.install_symlink dylib.basename => "#{dylib.basename(".dylib")}.so"
    end

    # This is either a solid argument for guile including options for
    # --with-xyz-prefix= for libffi and bdw-gc or a solid argument for
    # Homebrew automatically removing Cellar paths from .pc files in favour
    # of opt_prefix usage everywhere.
    inreplace lib/"pkgconfig/guile-3.0.pc" do |s|
      s.gsub! Formula["bdw-gc"].prefix.realpath, Formula["bdw-gc"].opt_prefix
      s.gsub! Formula["libffi"].prefix.realpath, Formula["libffi"].opt_prefix
    end

    (share/"gdb/auto-load").install Dir["#{lib}/*-gdb.scm"]
  end

  def post_install
    # Create directories so installed modules can create links inside.
    (HOMEBREW_PREFIX/"lib/guile/3.0/site-ccache").mkpath
    (HOMEBREW_PREFIX/"lib/guile/3.0/extensions").mkpath
    (HOMEBREW_PREFIX/"share/guile/site/3.0").mkpath
  end

  def caveats
    <<~EOS
      Guile libraries can now be installed here:
          Source files: #{HOMEBREW_PREFIX}/share/guile/site/3.0
        Compiled files: #{HOMEBREW_PREFIX}/lib/guile/3.0/site-ccache
            Extensions: #{HOMEBREW_PREFIX}/lib/guile/3.0/extensions

      Add the following to your .bashrc or equivalent:
        export GUILE_LOAD_PATH="#{HOMEBREW_PREFIX}/share/guile/site/3.0"
        export GUILE_LOAD_COMPILED_PATH="#{HOMEBREW_PREFIX}/lib/guile/3.0/site-ccache"
        export GUILE_SYSTEM_EXTENSIONS_PATH="#{HOMEBREW_PREFIX}/lib/guile/3.0/extensions"
    EOS
  end

  test do
    hello = testpath/"hello.scm"
    hello.write <<~EOS
      (display "Hello World")
      (newline)
    EOS

    ENV["GUILE_AUTO_COMPILE"] = "0"

    system bin/"guile", hello
  end
end
