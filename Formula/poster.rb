class Poster < Formula
  desc "Create large posters out of PostScript pages"
  homepage "https://schrfr.github.io/poster/"
  url "https://github.com/schrfr/poster/archive/1.0.0.tar.gz"
  sha256 "1df49dfd4e50ffd66e0b6e279b454a76329a36280e0dc73b08e5b5dcd5cff451"
  license "GPL-2.0"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/poster"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "ca7aad3be50d2a5df8a5c8a38e82a0af9ed38fdd0d1e30c08134918cbb61e509"
  end

  def install
    system "make"
    bin.install "poster"
    man1.install "poster.1"
  end

  test do
    system "#{bin}/poster", test_fixtures("test.ps")
  end
end
