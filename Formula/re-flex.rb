class ReFlex < Formula
  desc "Regex-centric, fast and flexible scanner generator for C++"
  homepage "https://www.genivia.com/doc/reflex/html"
  url "https://github.com/Genivia/RE-flex/archive/v3.0.3.tar.gz"
  sha256 "a046d8c9878b1c7af67a9c045a40cd6a0213589fbd9bd39beba3b11a368f580a"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "ac67c0676adb730ede83dbe114525d746f937c2b96294d52e6745b4a0a1bece2"
    sha256 cellar: :any_skip_relocation, big_sur:       "ee9e749782c136056a7edc2507579d879f686a741fe75f4dc2f1e61244b75e15"
    sha256 cellar: :any_skip_relocation, catalina:      "ad5f139f926fe5755effe22453644731ffd336ffe905906541901597ca0f7ae0"
    sha256 cellar: :any_skip_relocation, mojave:        "4ede92ed2cc77fd82e7bf281da45ce64c675e40be52d5a0378f61af01799b791"
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
