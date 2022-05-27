require "language/node"

class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-1.14.0.tgz"
  sha256 "ee35d4a1ed61f3fedf381b49a5689dff1b4ce015b9201cbd74a54154ee7489cd"
  license "MIT"
  head "https://github.com/contentful/contentful-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b09d883be2e691695f5e1ae5e0ed289ad0322a34d72dce320ec85ad4115ee691"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b09d883be2e691695f5e1ae5e0ed289ad0322a34d72dce320ec85ad4115ee691"
    sha256 cellar: :any_skip_relocation, monterey:       "4656e12e74f884b819d73436461ac7378fa8a3b00098503881cbf8f4eef7566d"
    sha256 cellar: :any_skip_relocation, big_sur:        "4656e12e74f884b819d73436461ac7378fa8a3b00098503881cbf8f4eef7566d"
    sha256 cellar: :any_skip_relocation, catalina:       "4656e12e74f884b819d73436461ac7378fa8a3b00098503881cbf8f4eef7566d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b09d883be2e691695f5e1ae5e0ed289ad0322a34d72dce320ec85ad4115ee691"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    output = shell_output("#{bin}/contentful space list 2>&1", 1)
    assert_match "🚨  Error: You have to be logged in to do this.", output
    assert_match "You can log in via contentful login", output
    assert_match "Or provide a management token via --management-token argument", output
  end
end
