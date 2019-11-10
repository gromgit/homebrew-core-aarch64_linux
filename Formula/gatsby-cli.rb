require "language/node"

class GatsbyCli < Formula
  desc "Gatsby command-line interface"
  homepage "https://www.gatsbyjs.org/docs/gatsby-cli/"
  url "https://registry.npmjs.org/gatsby-cli/-/gatsby-cli-2.8.9.tgz"
  sha256 "9b3f80e89ba9e1c663b3cf8544a7646a28c3c1848b1346238673fecddf8d054b"

  bottle do
    cellar :any_skip_relocation
    sha256 "17a79e59b64a039dd1c15e921c6907370a8c314d1838494b3128930f7581a7ad" => :catalina
    sha256 "796c489767b5a68a6d8f69bbeb38d0a72631ac7b489e1f032b904e333665aea7" => :mojave
    sha256 "047111580c4731c0f7e5f1f71256b649c7247cf74e48ac0431dd51119469bc39" => :high_sierra
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system bin/"gatsby", "new", "hello-world", "https://github.com/gatsbyjs/gatsby-starter-hello-world"
    assert_predicate testpath/"hello-world/package.json", :exist?, "package.json was not cloned"
  end
end
