class Bison < Formula
  desc "Parser generator"
  homepage "https://www.gnu.org/software/bison/"
  # X.Y.9Z are beta releases that sometimes get accidentally uploaded to the release FTP
  url "https://ftp.gnu.org/gnu/bison/bison-3.7.2.tar.xz"
  mirror "https://ftpmirror.gnu.org/bison/bison-3.7.2.tar.xz"
  sha256 "7948d193104d979c0fb0294a1854c73c89d72ae41acfc081826142578a78a91b"
  license "GPL-3.0-or-later"
  version_scheme 1

  livecheck do
    url :stable
  end

  bottle do
    sha256 "06b9ed55c9ba4905ffca2deecf94887aaa9804bd8b31fc4f9de16ffcba734916" => :catalina
    sha256 "7a5c7deaa448c57eefb129bbc2e030cf712a61cd94f877d90ec7976a8dbe1069" => :mojave
    sha256 "1a9fc9dc94461f1526b6556b395cc3a55c79e5f4c092fd07f762adb3a61b206a" => :high_sierra
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
