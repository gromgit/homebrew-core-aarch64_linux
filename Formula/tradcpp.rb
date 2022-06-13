class Tradcpp < Formula
  desc "K&R-style C preprocessor"
  homepage "https://www.netbsd.org/~dholland/tradcpp"
  url "https://cdn.netbsd.org/pub/NetBSD/misc/dholland/tradcpp-0.5.3.tar.gz"
  sha256 "e17b9f42cf74b360d5691bc59fb53f37e41581c45b75fcd64bb965e5e2fe4c5e"
  license "BSD-2-Clause"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/tradcpp"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "b2d193b09c26cb51169dae5e1cc1829f86154c879289523bd55aca43adc2a58b"
  end

  depends_on "bmake" => :build

  def install
    system "bmake"
    system "bmake", "prefix=#{prefix}", "MK_INSTALL_AS_USER=yes", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #define FOO bar
      FOO
    EOS
    assert_match "bar", shell_output(bin/"tradcpp ./test.c")
  end
end
