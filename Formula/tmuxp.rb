class Tmuxp < Formula
  include Language::Python::Virtualenv

  desc "Tmux session manager. Built on libtmux"
  homepage "https://tmuxp.git-pull.com/"
  url "https://files.pythonhosted.org/packages/9d/64/4ea3358fab42bedd4e8eb566382e0d8ffc0671b87759a9d8d630bdbc0096/tmuxp-1.8.1.tar.gz"
  sha256 "be5d473e645cfb98c1d745548046615dc609443ddfc184ab928186a653e38196"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "f5b388d9259be4de8674124ef0b3b6ca23ff2b72d73a87a8e59dc85a410f02ad"
    sha256 cellar: :any_skip_relocation, big_sur:       "8ff5a3324672681da0f52a92f418ad1f4bfc59de6342ba391f1b1a8ae63fcbe4"
    sha256 cellar: :any_skip_relocation, catalina:      "5016ad7f0da2622d3624517a1944dd79e2497053a1d5aa28f6aa95f31cfaed55"
    sha256 cellar: :any_skip_relocation, mojave:        "cad92b1d32803c9730cbe3e264ec5b15738fe8a0673b5b735fa949e58d54d337"
  end

  depends_on "python@3.9"
  depends_on "tmux"

  resource "click" do
    url "https://files.pythonhosted.org/packages/27/6f/be940c8b1f1d69daceeb0032fee6c34d7bd70e3e649ccac0951500b4720e/click-7.1.2.tar.gz"
    sha256 "d2b5255c7c6349bc1bd1e59e08cd12acbbd63ce649f2588755783aa94dfb6b1a"
  end

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/1f/bb/5d3246097ab77fa083a61bd8d3d527b7ae063c7d8e8671b1cf8c4ec10cbe/colorama-0.4.4.tar.gz"
    sha256 "5941b2b48a20143d2267e95b1c2a7603ce057ee39fd88e7329b0c292aa16869b"
  end

  resource "kaptan" do
    url "https://files.pythonhosted.org/packages/94/64/f492edfcac55d4748014b5c9f9a90497325df7d97a678c5d56443f881b7a/kaptan-0.5.12.tar.gz"
    sha256 "1abd1f56731422fce5af1acc28801677a51e56f5d3c3e8636db761ed143c3dd2"
  end

  resource "libtmux" do
    url "https://files.pythonhosted.org/packages/c4/90/a6df68839365ecb1b85b683f008830814deb87dd152acfab5652703d6a5f/libtmux-0.9.0.tar.gz"
    sha256 "c42727cbbcd02403cffb79c8ba8ea4f95ff1bd8c9328612fea537acd25e5ae16"
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
