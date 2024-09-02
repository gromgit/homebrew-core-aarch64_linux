class Ddrescue < Formula
  desc "GNU data recovery tool"
  homepage "https://www.gnu.org/software/ddrescue/ddrescue.html"
  url "https://ftp.gnu.org/gnu/ddrescue/ddrescue-1.26.tar.lz"
  mirror "https://ftpmirror.gnu.org/ddrescue/ddrescue-1.26.tar.lz"
  sha256 "e513cd3a90d9810dfdd91197d40aa40f6df01597bfb5ecfdfb205de1127c551f"
  license "GPL-2.0"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/ddrescue"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "0647abfe5a12233554db650163865b0e3996ccc513b5eafb32b9f3af31199b58"
  end

  def install
    system "./configure", "--prefix=#{prefix}",
                          "CXX=#{ENV.cxx}"
    system "make", "install"
  end

  test do
    system bin/"ddrescue", "--force", "--size=64Ki", "/dev/zero", "/dev/null"
  end
end
