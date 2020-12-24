class Lemon < Formula
  desc "LALR(1) parser generator like yacc or bison"
  homepage "https://www.hwaci.com/sw/lemon/"
  url "https://sqlite.org/2020/sqlite-src-3340000.zip"
  version "3.34.0"
  sha256 "a5c2000ece56d2de13c474658b9cdba6b7f2608a4d711e245518ea02a2a2333e"
  license "blessing"

  livecheck do
    url "https://sqlite.org/news.html"
    regex(%r{v?(\d+(?:\.\d+)+)</h3>}i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "e2871b39951595b238769253f3134631b41bacd23513ce7baf3211025a1e797c" => :big_sur
    sha256 "81fb0b45456f294af50bd1df1088360883ad6607a50c4e1e722b21b644f4c47a" => :catalina
    sha256 "fedd632bf40be50395eee85868c886e68495226e1922ca805dc5f5be2c923400" => :mojave
  end

  def install
    pkgshare.install "tool/lempar.c"

    # patch the parser generator to look for the 'lempar.c' template file where we've installed it
    inreplace "tool/lemon.c", "lempar.c", "#{pkgshare}/lempar.c"

    system ENV.cc, "-o", "lemon", "tool/lemon.c"
    bin.install "lemon"

    pkgshare.install "test/lemon-test01.y"
    doc.install "doc/lemon.html"
  end

  test do
    system "#{bin}/lemon", "-d#{testpath}", "#{pkgshare}/lemon-test01.y"
    system ENV.cc, "lemon-test01.c"
    assert_match "tests pass", shell_output("./a.out")
  end
end
