require "language/node"

class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-1.4.34.tgz"
  sha256 "2f87c60620184c3208b2ff89570df141ad372d1f7fb5f5f115484b137ef6d887"
  license "MIT"
  head "https://github.com/contentful/contentful-cli.git"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "59be2684f4358573f34d09fd1eabcd9eb42778e54b769c7a46b0ef7714deca22" => :catalina
    sha256 "378f5c43938ca16a926167748323f16abc82bca5afa76f91acc15b5da767cf2f" => :mojave
    sha256 "5d57fd61a6142795a5a8097d483b10e644b361e967bc67183d232ce5a94223f8" => :high_sierra
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
