class GnuCobol < Formula
  desc "Implements much of the COBOL 85 and COBOL 2002 standards"
  homepage "https://sourceforge.net/projects/gnucobol/"
  url "https://downloads.sourceforge.net/project/gnucobol/gnucobol/3.1/gnucobol-3.1.2.tar.xz"
  sha256 "597005d71fd7d65b90cbe42bbfecd5a9ec0445388639404662e70d53ddf22574"
  license "GPL-3.0-or-later"

  livecheck do
    url :stable
    regex(%r{url=.*?/gnucobol[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 "54120a32f1aca55dcf086ee8263460f8450ca7f2b35950f66577f43dbbce0228" => :big_sur
    sha256 "4adae6c3c543ee00f131df979b97f48ea93df1ae8ab984f3635e4ba3c1e35dd4" => :arm64_big_sur
    sha256 "0d347c1e84adebd9244bacdf8eb3ebce9250b077a745e18cab6a4cef0e804d51" => :catalina
    sha256 "b17301c541db62619dadfaae4c06bddbeff42fbc6a35e651655fe9e5db5cc733" => :mojave
  end

  depends_on "berkeley-db"
  depends_on "gmp"

  def install
    # both environment variables are needed to be set
    # the cobol compiler takes these variables for calling cc during its run
    # if the paths to gmp and bdb are not provided, the run of cobc fails
    gmp = Formula["gmp"]
    bdb = Formula["berkeley-db"]
    ENV.append "CPPFLAGS", "-I#{gmp.opt_include} -I#{bdb.opt_include}"
    ENV.append "LDFLAGS", "-L#{gmp.opt_lib} -L#{bdb.opt_lib}"

    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--with-libiconv-prefix=/usr",
                          "--with-libintl-prefix=/usr"
    system "make", "install"
  end

  test do
    (testpath/"hello.cob").write <<~EOS
            * COBOL must be indented
      000001 IDENTIFICATION DIVISION.
      000002 PROGRAM-ID. hello.
      000003 PROCEDURE DIVISION.
      000004 DISPLAY "Hello World!".
      000005 STOP RUN.
    EOS
    system "#{bin}/cobc", "-x", "hello.cob"
    system "./hello"
  end
end
