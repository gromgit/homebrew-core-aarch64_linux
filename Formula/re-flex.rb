class ReFlex < Formula
  desc "Regex-centric, fast and flexible scanner generator for C++"
  homepage "https://www.genivia.com/doc/reflex/html"
  url "https://github.com/Genivia/RE-flex/archive/v3.0.8.tar.gz"
  sha256 "7c3417c7aa5cb3193b553c3d62660fc9840850bd087ed153ca2e11bd4d295c03"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "d7f87624bdf9bff9c964d9e3195d899b01526966492f499db9086f5195ecd14f"
    sha256 cellar: :any_skip_relocation, big_sur:       "9e93004c722dc35f9f94b5ef63bf4a0f7c93c2c344afe81b2a8e057d4562b841"
    sha256 cellar: :any_skip_relocation, catalina:      "9eea02a065dc72094138e9fb990dbb3db31a5e24ab731989aadfc4667e835f2c"
    sha256 cellar: :any_skip_relocation, mojave:        "f02594f275bc1d4c9804a80e88b47964c94a4d21e101979b141b91214cac9738"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f7ad3f0ad374dae09f8ae449b8971e9bd42e71ec42ac0b0cf7d88f6bf8e58559"
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
