require "language/node"

class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-1.6.35.tgz"
  sha256 "b498a091975d2f7deaf01b36194b7fa9fc401bd73ae498f40c37a7621418e468"
  license "MIT"
  head "https://github.com/contentful/contentful-cli.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "04f0c1fdd1a8c297608a15bb5c6cd845c65054cf93765fbae57a3734d97e5c55"
    sha256 cellar: :any_skip_relocation, big_sur:       "9934ba9c56e9841da18d3de53a48ada40b63fa6f06b304a1104999fa3bba2ec8"
    sha256 cellar: :any_skip_relocation, catalina:      "9934ba9c56e9841da18d3de53a48ada40b63fa6f06b304a1104999fa3bba2ec8"
    sha256 cellar: :any_skip_relocation, mojave:        "9934ba9c56e9841da18d3de53a48ada40b63fa6f06b304a1104999fa3bba2ec8"
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
