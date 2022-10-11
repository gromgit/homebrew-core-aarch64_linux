class Tmuxp < Formula
  include Language::Python::Virtualenv

  desc "Tmux session manager. Built on libtmux"
  homepage "https://tmuxp.git-pull.com/"
  url "https://files.pythonhosted.org/packages/44/c3/6b367e516301bd90ce9f8a9f2faae171a576bf5cecf8aa1f5358011f6f4a/tmuxp-1.17.0.tar.gz"
  sha256 "4e63462a57e37d8134efeca51340fd4a91a28d0e2eff98e477afdc242c814b0b"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "33720327e2931a1d8065489748e465b0497f4c407a11a52132b9ecd566004e82"
    sha256 cellar: :any,                 arm64_big_sur:  "b4edd650125780e586ecef0e0913c4c71f8a542fca4d29167d4a0e372b5c01fb"
    sha256 cellar: :any,                 monterey:       "0b691da28de60941c6b0d1538a6841deffd3f625a5ce22105ce957792a18990d"
    sha256 cellar: :any,                 big_sur:        "d928d872e39466fb9b9c63030bb1cc380493677cceee2d43c424db1f1e75412a"
    sha256 cellar: :any,                 catalina:       "a4acfbc0da3a648c0c4f004ecd872ff88455083851d05bbda9bf367667b8eccf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5d51fbf84fccd7e2e0c73972082a09dccf6218d0639855d8d617b14bd1261b9e"
  end

  depends_on "python@3.10"
  depends_on "pyyaml"
  depends_on "tmux"

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/2b/65/24d033a9325ce42ccbfa3ca2d0866c7e89cc68e5b9d92ecaba9feef631df/colorama-0.4.5.tar.gz"
    sha256 "e6c6b4334fc50988a639d9b98aa429a0b57da6e17b9a44f0451f930b6967b7a4"
  end

  resource "libtmux" do
    url "https://files.pythonhosted.org/packages/35/1f/c3dbf187f823e80cd22ce4bba3d52857b0c0e6775310c14ac5f99417635d/libtmux-0.15.8.tar.gz"
    sha256 "cf352a645ebeaa5046ad0593cc01d691d77f8b3af1660327a6433cc6276ab796"
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
