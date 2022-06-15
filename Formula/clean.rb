class Clean < Formula
  desc "Search for files matching a regex and delete them"
  homepage "https://clean.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/clean/clean/3.4/clean-3.4.tar.bz2"
  sha256 "761f3a9e1ed50747b6a62a8113fa362a7cc74d359ac6e8e30ba6b30d59115320"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/clean"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "4e8c1a2fcd3bcf63119badd9f00280672285f92c1fe89df10c9d8e1bf9794a28"
  end

  def install
    system "make"
    bin.install "clean"
    man1.install "clean.1"
  end

  test do
    touch testpath/"backup1234"
    touch testpath/"backup1234.testing-rm"

    system bin/"clean", "-f", "-l", "-e", "*.testing-rm"
    assert_predicate testpath/"backup1234", :exist?
    refute_predicate testpath/"backup1234.testing-rm", :exist?
  end
end
