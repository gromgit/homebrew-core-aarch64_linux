class Pari < Formula
  desc "Computer algebra system designed for fast computations in number theory"
  homepage "https://pari.math.u-bordeaux.fr/"
  url "https://pari.math.u-bordeaux.fr/pub/pari/unix/pari-2.11.4.tar.gz"
  sha256 "bfc88fc4f7352f4840e6e352c72f0369cbea8a45403b1834a6269f3709970b1c"

  bottle do
    sha256 "bfac783202e3e6470d3ced0543dbebaf83a1da1b91f8f7bb191ab4bcc9ff3a19" => :catalina
    sha256 "ecac057aed38361682df4fd71803fc258e44e7b84907cfb3f82c7c4668979c4a" => :mojave
    sha256 "9504d484f5f4f7794355a0c0790d11cdd566f2b9d513a6b22a4aba207920eb06" => :high_sierra
  end

  depends_on "gmp"
  depends_on "readline"

  def install
    readline = Formula["readline"].opt_prefix
    gmp = Formula["gmp"].opt_prefix
    system "./Configure", "--prefix=#{prefix}",
                          "--with-gmp=#{gmp}",
                          "--with-readline=#{readline}",
                          "--graphic=ps"
    # make needs to be done in two steps
    system "make", "all"
    system "make", "install"

    # Avoid references to Homebrew shims
    inreplace lib/"pari/pari.cfg", HOMEBREW_LIBRARY/"Homebrew/shims/mac/super/", "/usr/bin/"
  end

  def caveats
    <<~EOS
      If you need the graphical plotting functions you need to install X11 with:
        brew cask install xquartz
    EOS
  end

  test do
    (testpath/"math.tex").write "$k_{n+1} = n^2 + k_n^2 - k_{n-1}$"
    system bin/"tex2mail", testpath/"math.tex"
  end
end
