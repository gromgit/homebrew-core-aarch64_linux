require "language/node"

class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-1.4.47.tgz"
  sha256 "18eab40913c6391045234bc65b279da14db4f41e80c6783f7d23ea2e0099c58f"
  license "MIT"
  head "https://github.com/contentful/contentful-cli.git"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "69a799a02cd70833151b4bdf28020a734dab648dc8f6bab49963765f6e92debb" => :catalina
    sha256 "f6013a52ec4352b4d196df023c9af2c155d868d81ea8c51ad960d2dc3ae0a4c3" => :mojave
    sha256 "be770440126268407db7b7da2c8c1a05a052979f678d1a009221059ee0b87d24" => :high_sierra
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
