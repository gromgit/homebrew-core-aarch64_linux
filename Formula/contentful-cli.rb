require "language/node"

class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-1.4.13.tgz"
  sha256 "2f03f9ed48f521823bae98fd5056510542c6329f85988597c1dfc4bb0c176614"
  head "https://github.com/contentful/contentful-cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "fd58d14f032799d5c3a3494c3d3023cec92b021d646863651d88f0011c612352" => :catalina
    sha256 "37f359f3ce3eefdea61c9880955d181c52210d22ed728ab9b8493079e5a2215c" => :mojave
    sha256 "1a5f412a841b2bf7cb14d48e4b2c99c4c915dc2400c3a44f9c5ffd9dd98474e8" => :high_sierra
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
    assert_match "Or provide a managementToken via --management-Token argument", output
  end
end
