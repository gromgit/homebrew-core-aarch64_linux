require "language/node"

class Nativefier < Formula
  desc "Wrap web apps natively"
  homepage "https://github.com/nativefier/nativefier"
  url "https://registry.npmjs.org/nativefier/-/nativefier-49.0.1.tgz"
  sha256 "d092716386eb6e05c19694683b4dfecc5d014529d41f86206371ca78fcd100c0"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3564975a5663376a6d4f3d33d2cafa623ac99ce3ceb7c6136bbce5d569287232"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3564975a5663376a6d4f3d33d2cafa623ac99ce3ceb7c6136bbce5d569287232"
    sha256 cellar: :any_skip_relocation, monterey:       "66e5b6904b04b80c3b41f2ba5be50a594396926540570f1d9097e8f2c0108746"
    sha256 cellar: :any_skip_relocation, big_sur:        "66e5b6904b04b80c3b41f2ba5be50a594396926540570f1d9097e8f2c0108746"
    sha256 cellar: :any_skip_relocation, catalina:       "66e5b6904b04b80c3b41f2ba5be50a594396926540570f1d9097e8f2c0108746"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3564975a5663376a6d4f3d33d2cafa623ac99ce3ceb7c6136bbce5d569287232"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/nativefier --version")
  end
end
