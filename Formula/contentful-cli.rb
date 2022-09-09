require "language/node"

class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-1.15.5.tgz"
  sha256 "1ded1f16fb2758abc1a49b8a41c5504294c66cf16e132c12d876b3a2ebd8ca68"
  license "MIT"
  head "https://github.com/contentful/contentful-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e79f04003f3c15da5d5ad5684c2b96d1c677e84e2ab2ec94bb876e04b7d4754c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e79f04003f3c15da5d5ad5684c2b96d1c677e84e2ab2ec94bb876e04b7d4754c"
    sha256 cellar: :any_skip_relocation, monterey:       "1964532e27bf4c68b98c31f4ab5fe3ed30086dfcda42ab6fbd2f90a32f261927"
    sha256 cellar: :any_skip_relocation, big_sur:        "1964532e27bf4c68b98c31f4ab5fe3ed30086dfcda42ab6fbd2f90a32f261927"
    sha256 cellar: :any_skip_relocation, catalina:       "1964532e27bf4c68b98c31f4ab5fe3ed30086dfcda42ab6fbd2f90a32f261927"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e79f04003f3c15da5d5ad5684c2b96d1c677e84e2ab2ec94bb876e04b7d4754c"
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
