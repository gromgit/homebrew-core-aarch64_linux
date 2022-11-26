class SwiProlog < Formula
  desc "ISO/Edinburgh-style Prolog interpreter"
  homepage "https://www.swi-prolog.org/"
  url "https://www.swi-prolog.org/download/stable/src/swipl-9.0.0.tar.gz"
  sha256 "d607733a776ca56b3ecb2118119d4ae08a8790ef4aaa08bbe8f2279f34fba4b8"
  license "BSD-2-Clause"
  head "https://github.com/SWI-Prolog/swipl-devel.git", branch: "master"

  livecheck do
    url "https://www.swi-prolog.org/download/stable/src/"
    regex(/href=.*?swipl[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "dad61a951cffa77ceb44aecafc285beafe76d08edf23b2520a1c03f3b7a631da"
    sha256 arm64_monterey: "96a4d387468c9c72a7c156d6fb840cfca4f2801c8fd614196c137340c7223e77"
    sha256 arm64_big_sur:  "4e979626e5e8bac0dcb34fc8312471fdc3132cfdbca9bba558b48d82fc48f521"
    sha256 ventura:        "797bcd246f7b018e5a09de85f89c25f931a1cc08bb619ddc0edb80c1c730a421"
    sha256 monterey:       "b30ae2ffde43ff63f9998f65546d4d02e8efa3aae0d82964173fa8ed50e3d171"
    sha256 big_sur:        "629a08d96c0e958a3938567b07dc65e8dbc12985401396d4f74f7c0b924832cf"
    sha256 catalina:       "268f7ae65b31dc579a80c985688a7638829af9ad73b9a6e453b5cacb89bdb0ae"
    sha256 x86_64_linux:   "304b23b5ca22215e33415000849b0a36c267e3db3a81f13f9fd0da0aa7f896d2"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "berkeley-db@4"
  depends_on "gmp"
  depends_on "libarchive"
  depends_on "libyaml"
  depends_on "openssl@3"
  depends_on "pcre"
  depends_on "readline"
  depends_on "unixodbc"

  uses_from_macos "libxcrypt"
  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  def install
    # Remove shim paths from binary files `swipl-ld` and `libswipl.so.*`
    if OS.linux?
      inreplace "cmake/Params.cmake" do |s|
        s.gsub! "${CMAKE_C_COMPILER}", "\"gcc\""
        s.gsub! "${CMAKE_CXX_COMPILER}", "\"g++\""
      end
    end

    args = ["-DSWIPL_PACKAGES_JAVA=OFF", "-DSWIPL_PACKAGES_X=OFF", "-DCMAKE_INSTALL_RPATH=#{loader_path}"]
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args(install_prefix: libexec)
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    bin.write_exec_script (libexec/"bin").children
  end

  test do
    (testpath/"test.pl").write <<~EOS
      test :-
          write('Homebrew').
    EOS
    assert_equal "Homebrew", shell_output("#{bin}/swipl -s #{testpath}/test.pl -g test -t halt")
  end
end
