class Pari < Formula
  desc "Computer algebra system designed for fast computations in number theory"
  homepage "https://pari.math.u-bordeaux.fr/"
  url "https://pari.math.u-bordeaux.fr/pub/pari/unix/pari-2.13.2.tar.gz"
  sha256 "1679985094a0b723d14f49aa891dbe5ec967aa4040050a2c50bd764ddb3eba24"
  license "GPL-2.0-or-later"
  revision 2

  livecheck do
    url "https://pari.math.u-bordeaux.fr/pub/pari/unix/"
    regex(/href=.*?pari[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "8b7ed66542790052cdf4a5792ac3686fedc43e69b5d643f6e8fbbc04d3d7c6aa"
    sha256 cellar: :any,                 big_sur:       "789d72fe3f7a8b53bb4f95735f1f3849e479050d1f8ddcdedc35f96bc3ed8e16"
    sha256 cellar: :any,                 catalina:      "56a92398748eb0ab496165049096e138a6d5e7f18f44bbfe18c94743c25f9893"
    sha256 cellar: :any,                 mojave:        "db4da067cb412e1ed6125d847e566dd70ec834f6fa81fc7854881e66cc42fd5e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "67676d86e22365ec431d7c87433657c21db5126263429967e1a5210a66ccc83d"
  end

  depends_on "gmp"
  depends_on "readline"

  def install
    readline = Formula["readline"].opt_prefix
    gmp = Formula["gmp"].opt_prefix
    system "./Configure", "--prefix=#{prefix}",
                          "--with-gmp=#{gmp}",
                          "--with-readline=#{readline}",
                          "--graphic=ps",
                          "--mt=pthread"

    # Explicitly set datadir to HOMEBREW_PREFIX/share/pari to allow for external packages to be found
    # We do this here rather than in configure because we still want the actual files to be installed to the Cellar
    objdir = Utils.safe_popen_read("./config/objdir").chomp
    inreplace %W[#{objdir}/pari.cfg #{objdir}/paricfg.h], pkgshare, "#{HOMEBREW_PREFIX}/share/pari"

    # make needs to be done in two steps
    system "make", "all"
    system "make", "install"

    os = "mac"
    on_linux { os = "linux" }
    # Avoid references to Homebrew shims
    inreplace lib/"pari/pari.cfg", HOMEBREW_LIBRARY/"Homebrew/shims/#{os}/super/", "/usr/bin/"
  end

  def caveats
    <<~EOS
      If you need the graphical plotting functions you need to install X11 with:
        brew install --cask xquartz
    EOS
  end

  test do
    (testpath/"math.tex").write "$k_{n+1} = n^2 + k_n^2 - k_{n-1}$"
    system bin/"tex2mail", testpath/"math.tex"
  end
end
