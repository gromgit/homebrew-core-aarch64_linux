class Bison < Formula
  desc "Parser generator"
  homepage "https://www.gnu.org/software/bison/"
  # X.Y.9Z are beta releases that sometimes get accidentally uploaded to the release FTP
  url "https://ftp.gnu.org/gnu/bison/bison-3.5.4.tar.xz"
  mirror "https://ftpmirror.gnu.org/bison/bison-3.5.4.tar.xz"
  sha256 "4c17e99881978fa32c05933c5262457fa5b2b611668454f8dc2a695cd6b3720c"
  version_scheme 1

  bottle do
    rebuild 1
    sha256 "936499e7f3bb0ee0873930232715fd2a17e37cb26c1e520974dc78a969f34adb" => :catalina
    sha256 "01beb7900fbbe23726079805d1d8527dce8a1dcde51da583cb4b032b560efc03" => :mojave
    sha256 "e27f3e55044f6adbbe49c634c0dd9c289a72efb32c2d81731e43309b0f2794de" => :high_sierra
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
