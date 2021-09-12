class Bison < Formula
  desc "Parser generator"
  homepage "https://www.gnu.org/software/bison/"
  # X.Y.9Z are beta releases that sometimes get accidentally uploaded to the release FTP
  url "https://ftp.gnu.org/gnu/bison/bison-3.8.tar.xz"
  mirror "https://ftpmirror.gnu.org/bison/bison-3.8.tar.xz"
  sha256 "1e0a14a8bf52d878e500c33d291026b9ebe969c27b3998d4b4285ab6dbce4527"
  license "GPL-3.0-or-later"
  version_scheme 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "77122849bbea244353105d6d820e0ec97f08e511bbef8a5ec9291a77c0f2256e"
    sha256 cellar: :any_skip_relocation, big_sur:       "ac7e42c9d0356549683eef548e969e2107271a4d5b3e2307b22648056b3d8a10"
    sha256 cellar: :any_skip_relocation, catalina:      "12d1897e723aa58ec33e149eaba1da6385a1faadaaddf71f9ed97f0f7039c395"
    sha256 cellar: :any_skip_relocation, mojave:        "f20f2029b67798bebb691be2dbdc5bf3ae752e31fa65d7360b9487a83c37f1c2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e249bcde22dd8db752b41ea9f58bbe442cc6f8a630f6afe8fb575b3f5fe40352"
  end

  keg_only :provided_by_macos

  uses_from_macos "m4"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--enable-relocatable",
                          "--prefix=/output",
                          "M4=m4"
    system "make", "install", "DESTDIR=#{buildpath}"
    prefix.install Dir["#{buildpath}/output/*"]
  end

  test do
    (testpath/"test.y").write <<~EOS
      %{ #include <iostream>
         using namespace std;
         extern void yyerror (char *s);
         extern int yylex ();
      %}
      %start prog
      %%
      prog:  //  empty
          |  prog expr '\\n' { cout << "pass"; exit(0); }
          ;
      expr: '(' ')'
          | '(' expr ')'
          |  expr expr
          ;
      %%
      char c;
      void yyerror (char *s) { cout << "fail"; exit(0); }
      int yylex () { cin.get(c); return c; }
      int main() { yyparse(); }
    EOS
    system "#{bin}/bison", "test.y"
    system ENV.cxx, "test.tab.c", "-o", "test"
    assert_equal "pass", shell_output("echo \"((()(())))()\" | ./test")
    assert_equal "fail", shell_output("echo \"())\" | ./test")
  end
end
