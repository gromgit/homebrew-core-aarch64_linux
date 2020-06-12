require "language/node"

class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-1.4.10.tgz"
  sha256 "fe7a3787e68fb33b349bb721ff9fb82a6ae370567355455e8618d666fb6d2a56"
  head "https://github.com/contentful/contentful-cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "77a0ace140706ad9a0613c585d0b419c3170232e1e4719891ca49b36cab5ba91" => :catalina
    sha256 "8ac68f7a2c3fb13f0127021c97c448e7a8408da9a6484d250b060f079aa90f35" => :mojave
    sha256 "11b0ac1f6bcaaf4d175ab94e987d089164cd73b7779afc86f208182831d56cb0" => :high_sierra
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
