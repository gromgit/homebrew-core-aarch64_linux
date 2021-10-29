class Asciidoc < Formula
  include Language::Python::Virtualenv

  desc "Formatter/translator for text files to numerous formats"
  homepage "https://asciidoc-py.github.io/"
  url "https://files.pythonhosted.org/packages/b9/5a/cefa14bb228c790de12bd52a4d7537cee7e6acbb73d21198b4d4fec2c92f/asciidoc-10.0.1.tar.gz"
  sha256 "cb222ba0ec3d3e786041b91cbc91f310d0f19bbc49df65af3278ae67505aff47"
  license "GPL-2.0-only"
  head "https://github.com/asciidoc-py/asciidoc-py.git", branch: "main"

  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1fdfa8e89388fd98cc6b95e4e3aa982af82828361b52adc093c49d8f5d93f215"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1fdfa8e89388fd98cc6b95e4e3aa982af82828361b52adc093c49d8f5d93f215"
    sha256 cellar: :any_skip_relocation, monterey:       "fd1dae6a59a718a230623c4ced9a8dd9363471f2222b1992a5db617a3e3d8614"
    sha256 cellar: :any_skip_relocation, big_sur:        "fd1dae6a59a718a230623c4ced9a8dd9363471f2222b1992a5db617a3e3d8614"
    sha256 cellar: :any_skip_relocation, catalina:       "fd1dae6a59a718a230623c4ced9a8dd9363471f2222b1992a5db617a3e3d8614"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "057a90f2c53ade6b7513e509a7b5d540158bb22a679533627f12b92c8bd46514"
  end

  depends_on "docbook"
  depends_on "python@3.10"
  depends_on "source-highlight"

  def install
    virtualenv_install_with_resources
  end

  def caveats
    <<~EOS
      If you intend to process AsciiDoc files through an XML stage
      (such as a2x for manpage generation) you need to add something
      like:

        export XML_CATALOG_FILES=#{etc}/xml/catalog

      to your shell rc file so that xmllint can find AsciiDoc's
      catalog files.

      See `man 1 xmllint' for more.
    EOS
  end

  test do
    (testpath/"test.txt").write("== Hello World!")
    system "#{bin}/asciidoc", "-b", "html5", "-o", testpath/"test.html", testpath/"test.txt"
    assert_match %r{<h2 id="_hello_world">Hello World!</h2>}, File.read(testpath/"test.html")
  end
end
