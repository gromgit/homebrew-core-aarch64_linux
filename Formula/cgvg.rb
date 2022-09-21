class Cgvg < Formula
  desc "Command-line source browsing tool"
  homepage "https://uzix.org/cgvg.html"
  url "https://uzix.org/cgvg/cgvg-1.6.3.tar.gz"
  sha256 "d879f541abcc988841a8d86f0c0781ded6e70498a63c9befdd52baf4649a12f3"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?cgvg[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/cgvg"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "2a2ede7db0926ddbc1f83fee597b4f1cdc636e0c5850fda3b64e64c892211659"
  end

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make", "install"
  end

  test do
    (testpath/"test").write "Homebrew"
    assert_match "1 Homebrew", shell_output("#{bin}/cg Homebrew '#{testpath}/test'")
  end
end
