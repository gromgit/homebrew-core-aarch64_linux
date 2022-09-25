class Tmuxp < Formula
  include Language::Python::Virtualenv

  desc "Tmux session manager. Built on libtmux"
  homepage "https://tmuxp.git-pull.com/"
  url "https://files.pythonhosted.org/packages/b5/7b/321352ec6763e80fdd2e0ddd0a406c3125d1e220d9063174246031fd578b/tmuxp-1.15.2.tar.gz"
  sha256 "9b6bd7ab29368f6b4c96c4b9dbeb90be58e687300298728c134197c404b5a777"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "282efd12b665b8ed8be9725f39f8bbc225940f065a41876392f966cdd1b5c865"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7ab689139730251b5a5759496d76086f70c02ae16b6299749a505e8043b43762"
    sha256 cellar: :any_skip_relocation, monterey:       "c61899330368dec20662e57120754db5b87c3187a859adb730ae53bd8cfef04a"
    sha256 cellar: :any_skip_relocation, big_sur:        "82f5f089762a1c107f846721176b898c5fb4348a396233e3e40abf016978fd29"
    sha256 cellar: :any_skip_relocation, catalina:       "75972b305cc8de76f2183bea21f1a0f30d855fa47248afd2a3e02bc56babafb7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3055c200eb2fdd6ba43db519292853c459843403cb531d00068ada05aae5d12a"
  end

  depends_on "python@3.10"
  depends_on "tmux"

  resource "click" do
    url "https://files.pythonhosted.org/packages/59/87/84326af34517fca8c58418d148f2403df25303e02736832403587318e9e8/click-8.1.3.tar.gz"
    sha256 "7682dc8afb30297001674575ea00d1814d808d6a36af415a82bd481d37ba7b8e"
  end

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/2b/65/24d033a9325ce42ccbfa3ca2d0866c7e89cc68e5b9d92ecaba9feef631df/colorama-0.4.5.tar.gz"
    sha256 "e6c6b4334fc50988a639d9b98aa429a0b57da6e17b9a44f0451f930b6967b7a4"
  end

  resource "kaptan" do
    url "https://files.pythonhosted.org/packages/94/64/f492edfcac55d4748014b5c9f9a90497325df7d97a678c5d56443f881b7a/kaptan-0.5.12.tar.gz"
    sha256 "1abd1f56731422fce5af1acc28801677a51e56f5d3c3e8636db761ed143c3dd2"
  end

  resource "libtmux" do
    url "https://files.pythonhosted.org/packages/e7/ff/57093d287ae579f4fbf357a072b92551663cca95588c4835a86fd0130ff3/libtmux-0.15.7.tar.gz"
    sha256 "dee2a138e0eab14256472d140ac816c923c303406b894e27c068cc39f5f8bfb4"
  end

  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/a0/a4/d63f2d7597e1a4b55aa3b4d6c5b029991d3b824b5bd331af8d4ab1ed687d/PyYAML-5.4.1.tar.gz"
    sha256 "607774cbba28732bfa802b54baa7484215f530991055bb562efbed5b2f20a45e"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tmuxp --version")

    (testpath/"test_session.yaml").write <<~EOS
      session_name: 2-pane-vertical
      windows:
      - window_name: my test window
        panes:
          - echo hello
          - echo hello
    EOS

    system bin/"tmuxp", "debug-info"
    system bin/"tmuxp", "convert", "--yes", "test_session.yaml"
    assert_predicate testpath/"test_session.json", :exist?
  end
end
