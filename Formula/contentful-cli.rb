require "language/node"

class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-1.4.30.tgz"
  sha256 "f6d1ae178f74b302b603263b59adec0056f681a40ef5a7df663e9884170e9e2a"
  license "MIT"
  head "https://github.com/contentful/contentful-cli.git"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "b7c12c1b74ecad2bd75501159beb7a9ba779b420b3a233aacd90e6d5b3979292" => :catalina
    sha256 "47d5744c91b803e68cfec5e1c292d6fa500b63e0f378b4948ae0533224ac3225" => :mojave
    sha256 "d468608c0ad07e5415df1bea226f6f987d8620ec139e2d9ad740cb1c4cc6f6c6" => :high_sierra
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
