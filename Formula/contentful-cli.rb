require "language/node"

class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-1.3.28.tgz"
  sha256 "1769b9d86d686c69696ee940161be79f35c6ae6452f0e4d82de8d88349b7a212"
  head "https://github.com/contentful/contentful-cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "724832fe4e310adffe7ed41e059c89c1ae4eadabd67b8f7512ecd6b9040d12be" => :catalina
    sha256 "457f7d26f5199eadfd97a2b281b4b13e0cdcbc1840b73c96c7dfb6f08690dde6" => :mojave
    sha256 "871fd8dbfd25f9310c7c23fb4f9be677838ba056aa118e8ac28d4532eb6e8f1d" => :high_sierra
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
