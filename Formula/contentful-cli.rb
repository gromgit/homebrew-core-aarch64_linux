require "language/node"

class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-1.4.14.tgz"
  sha256 "541724e13da9a6b6ce6998cd61888bb45b4c631b5fe4efc84708b693112cff42"
  head "https://github.com/contentful/contentful-cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "2752d7ef4ed2b7f00bbcbe4dfe93f0516f5ed8dd0401be822720e3a33ea2edf6" => :catalina
    sha256 "ec0bcab94a2eaf2a17b8240eb220590dafe59300ed882ef17ce97c5089057428" => :mojave
    sha256 "95231d25c9db3c6c51dca74f961da35057758e1313cd2e2eedada94a1db402b6" => :high_sierra
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
