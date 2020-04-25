require "language/node"

class BalenaCli < Formula
  desc "The official balena CLI tool"
  homepage "https://www.balena.io/docs/reference/cli/"
  # Frequent upstream releases, do not update more than once a week
  url "https://registry.npmjs.org/balena-cli/-/balena-cli-11.31.21.tgz"
  sha256 "3919b9f8559c6368242184268bf2b95e58e4bf2b42699095dcdc930160de880e"

  bottle do
    sha256 "fe9c12ad77eb7e36d8633787a0d5234a903011f3f05129f5cf04e50eeff46f77" => :catalina
    sha256 "7835f6cb5f63c4b1ac3fff483e48f57d9227cbbc787f460a6699c0ab40d6c743" => :mojave
    sha256 "a5819f92adbfddd79ca10e05fa84b4430a4f93c09e2bc6c18366369731f990bb" => :high_sierra
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match "Logging in to balena-cloud.com",
      shell_output("#{bin}/balena login --credentials --email johndoe@gmail.com --password secret 2>/dev/null", 1)
  end
end
