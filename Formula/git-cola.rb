class GitCola < Formula
  desc "Highly caffeinated git GUI"
  homepage "https://git-cola.github.io/"
  url "https://github.com/git-cola/git-cola/archive/v3.5.tar.gz"
  sha256 "7fdcfc4326b35e384b97bd4bb2189b4cb5cf258948352759c302e632b41bb2e2"
  revision 1
  head "https://github.com/git-cola/git-cola.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "0420dfa06bdd89ee3cac8e02c849cc0ebe4d54e9c1721cca78d876321125f8d1" => :mojave
    sha256 "a8b5c5c2a1a176db45edd89c28f3e4656aa6617ed3490ec9abc71310e5d7276f" => :high_sierra
  end

  depends_on "sphinx-doc" => :build
  depends_on "pyqt"
  depends_on "python"

  def install
    ENV.delete("PYTHONPATH")
    system "make", "PYTHON=python3", "prefix=#{prefix}", "install"
    system "make", "install-doc", "PYTHON=python3", "prefix=#{prefix}",
           "SPHINXBUILD=#{Formula["sphinx-doc"].opt_bin}/sphinx-build"
  end

  test do
    system "#{bin}/git-cola", "--version"
  end
end
