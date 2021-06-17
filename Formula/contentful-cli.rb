require "language/node"

class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-1.8.0.tgz"
  sha256 "e02d0f73f6f0c0b6a194569f9070adc3819c220983d1aba593254cd56722fa6f"
  license "MIT"
  head "https://github.com/contentful/contentful-cli.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "66354ddd406a207e35fff2e08bcdcee70f27c620689e63d0112b6798edd13926"
    sha256 cellar: :any_skip_relocation, big_sur:       "f59841eba8b1dcafc7c6c89bbead2bc1aab4f92fa4cac470deb72bd1645525f1"
    sha256 cellar: :any_skip_relocation, catalina:      "f59841eba8b1dcafc7c6c89bbead2bc1aab4f92fa4cac470deb72bd1645525f1"
    sha256 cellar: :any_skip_relocation, mojave:        "f59841eba8b1dcafc7c6c89bbead2bc1aab4f92fa4cac470deb72bd1645525f1"
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
