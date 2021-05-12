require "language/node"

class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-1.6.25.tgz"
  sha256 "669851135164be1e872e1f6fb0f4147bc626f0b48d88e54832f5ccc024d2e533"
  license "MIT"
  head "https://github.com/contentful/contentful-cli.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "5fcb93a485042bae6a043d7dbeac47e57eedb23bcace01cef61091175c38bb0c"
    sha256 cellar: :any_skip_relocation, big_sur:       "358dfab0d251d686a5ae1680c3639edc8346f9c0adc27e2679a134bb0598fa22"
    sha256 cellar: :any_skip_relocation, catalina:      "358dfab0d251d686a5ae1680c3639edc8346f9c0adc27e2679a134bb0598fa22"
    sha256 cellar: :any_skip_relocation, mojave:        "358dfab0d251d686a5ae1680c3639edc8346f9c0adc27e2679a134bb0598fa22"
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
