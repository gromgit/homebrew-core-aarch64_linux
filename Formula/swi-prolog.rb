class SwiProlog < Formula
  desc "ISO/Edinburgh-style Prolog interpreter"
  homepage "https://www.swi-prolog.org/"
  url "https://www.swi-prolog.org/download/stable/src/swipl-8.2.0.tar.gz"
  sha256 "d8c9f3adb9cd997a5fed7b5f5dbfe971d2defda969b9066ada158e4202c09c3c"
  head "https://github.com/SWI-Prolog/swipl-devel.git"

  bottle do
    sha256 "1353754ee8858e0929e958524adbba7301066c06e15da07ab62efbee0d8e7add" => :catalina
    sha256 "d8ddd94fe8e3631cc32ce38a3a7c81a32c3a3798ada1d99779a82ea51c2305bb" => :mojave
    sha256 "26e7b1f2bed68d5b79cfaeb59f1185f8f215bedda355876e08386b3b88bbebe5" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "berkeley-db"
  depends_on "gmp"
  depends_on "jpeg"
  depends_on "libarchive"
  depends_on "libyaml"
  depends_on "openssl@1.1"
  depends_on "pcre"
  depends_on "readline"
  depends_on "unixodbc"

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args,
                      "-DSWIPL_PACKAGES_JAVA=OFF",
                      "-DSWIPL_PACKAGES_X=OFF",
                      "-DCMAKE_INSTALL_PREFIX=#{libexec}",
                      "-DCMAKE_C_COMPILER=/usr/bin/clang",
                      "-DCMAKE_CXX_COMPILER=/usr/bin/clang++"
      system "make", "install"
    end

    bin.write_exec_script Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"test.pl").write <<~EOS
      test :-
          write('Homebrew').
    EOS
    assert_equal "Homebrew", shell_output("#{bin}/swipl -s #{testpath}/test.pl -g test -t halt")
  end
end
