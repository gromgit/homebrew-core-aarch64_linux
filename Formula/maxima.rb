class Maxima < Formula
  desc "Computer algebra system"
  homepage "https://maxima.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/maxima/Maxima-source/5.43.1-source/maxima-5.43.1.tar.gz"
  sha256 "4ac6157fd9d8cb14d5fd1c6fb523ecce208fc184b46005b27f9babc097740738"

  bottle do
    cellar :any_skip_relocation
    sha256 "2f114e3e8e81a92098679cfe317249b34b30487942dc1188c29f1bb4d47ae234" => :catalina
    sha256 "2ba4476c009fdc87633fc27f55b344b20920b6daf14ee0c0b6afc58af66d819b" => :mojave
    sha256 "3b8a7c561dc3d11c0fd96fdef341f58a05a4b1d51f045b4e78a28bd9ef478383" => :high_sierra
  end

  depends_on "sbcl" => :build
  depends_on "gettext"
  depends_on "gnuplot"
  depends_on "rlwrap"

  def install
    ENV["LANG"] = "C" # per build instructions
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-gettext",
                          "--enable-sbcl",
                          "--enable-sbcl-exec",
                          "--with-emacs-prefix=#{share}/emacs/site-lisp/#{name}",
                          "--with-sbcl=#{Formula["sbcl"].opt_bin}/sbcl"
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/maxima", "--batch-string=run_testsuite(); quit();"
  end
end
