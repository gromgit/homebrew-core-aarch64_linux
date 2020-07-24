class Bison < Formula
  desc "Parser generator"
  homepage "https://www.gnu.org/software/bison/"
  # X.Y.9Z are beta releases that sometimes get accidentally uploaded to the release FTP
  url "https://ftp.gnu.org/gnu/bison/bison-3.7.tar.xz"
  mirror "https://ftpmirror.gnu.org/bison/bison-3.7.tar.xz"
  sha256 "07b25fbf4de2f2c686e8bff50fdb69efda49b6f9f7377dad1884f9508a28592b"
  license "GPL-3.0"
  version_scheme 1

  bottle do
    sha256 "fd7bc272775039f1181d2000a5b877ff92b9202cddbfa9051d622642316ecb6a" => :catalina
    sha256 "3ea1a383d295dfd8ec027d89202a676f01560615c562e654e404990be9779ec1" => :mojave
    sha256 "a63a87754022c05bcd973794d710f1488d03b5da778bcc3572d1671a79d2c142" => :high_sierra
  end

  keg_only :provided_by_macos

  uses_from_macos "m4"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
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
