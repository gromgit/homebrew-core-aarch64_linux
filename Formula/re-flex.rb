class ReFlex < Formula
  desc "The regex-centric, fast and flexible scanner generator for C++"
  homepage "https://www.genivia.com/doc/reflex/html"
  url "https://github.com/Genivia/RE-flex/archive/v2.0.1.tar.gz"
  sha256 "19364ee48ec30b141210538f2f2d467d64db04d9567ffa0a0c87a44e665c3e2b"

  bottle do
    cellar :any_skip_relocation
    sha256 "a071e974001152622adff0f712d5b4dab9f8e8d8a9b01f5b19dee9b138d5710c" => :catalina
    sha256 "99a40921e321271478e36b7db91f9023f5f9a6364af391878b6b1640447191b2" => :mojave
    sha256 "8c4c45dcd7566c848053bdf013cb5426ffd2801d0972ed6c231097ef85a9ce08" => :high_sierra
  end

  depends_on "pcre2"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"echo.l").write <<~'EOS'
      %{
      #include <stdio.h>
      %}
      %option noyywrap main
      %%
      .+  ECHO;
      %%
    EOS
    system "#{bin}/reflex", "--flex", "echo.l"
    assert_predicate testpath/"lex.yy.cpp", :exist?
  end
end
