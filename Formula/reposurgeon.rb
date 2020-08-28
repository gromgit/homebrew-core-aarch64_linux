class Reposurgeon < Formula
  desc "Edit version-control repository history"
  homepage "http://www.catb.org/esr/reposurgeon/"
  url "https://gitlab.com/esr/reposurgeon.git",
    tag:      "4.18",
    revision: "e312f1f9a5a0d3bf8b48a0e11cfcaf06178a97c3"
  license "BSD-2-Clause"
  head "https://gitlab.com/esr/reposurgeon.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "26b2730125a89f91693a8f72a432e15636f360488a0a7c903e3965ebc163cf17" => :catalina
    sha256 "6e7d739eaa6d373260e2c50a51772c72a50a752c43c1dd82a0ceb0eb3ee8ffe5" => :mojave
    sha256 "76d3fb73ace158588821df7eb61fb951cb97affcb2811f3d704d9b061c970963" => :high_sierra
  end

  depends_on "asciidoctor" => :build
  depends_on "go" => :build
  depends_on "git" # requires >= 2.19.2

  def install
    ENV["XML_CATALOG_FILES"] = "#{etc}/xml/catalog"
    system "make"
    system "make", "install", "prefix=#{prefix}"
    elisp.install "reposurgeon-mode.el"
  end

  test do
    (testpath/".gitconfig").write <<~EOS
      [user]
        name = Real Person
        email = notacat@hotmail.cat
    EOS
    system "git", "init"
    system "git", "commit", "--allow-empty", "--message", "brewing"

    assert_match "brewing",
      shell_output("script -q /dev/null #{bin}/reposurgeon read list")
  end
end
