require "language/node"

class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-1.3.23.tgz"
  sha256 "bd25f4fdb50dcfb1256ef6ea14a61f5e0fb53a3eaba18657a7abc6ea07da43f8"
  head "https://github.com/contentful/contentful-cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "ef9c5b57a36175c9e6582ddb025940e2b9065f0eb01b8ce87a0b301b4848d40c" => :catalina
    sha256 "7181407982eeb8b68c92ec387ee655212ee5067d8ef62d486c246ef6e93b0acb" => :mojave
    sha256 "0d12e5986b726d68cad8863a9e776e83f355541f5f8ccbe06897bc50d61df359" => :high_sierra
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
