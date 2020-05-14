require "language/node"

class Lerna < Formula
  desc "Tool for managing JavaScript projects with multiple packages"
  homepage "https://lerna.js.org"
  url "https://registry.npmjs.org/lerna/-/lerna-3.21.0.tgz"
  sha256 "8c58bb198ade38036467fe1ef7868ccd6f1da7c41aa300d0d446d895137c0a5e"

  bottle do
    cellar :any_skip_relocation
    sha256 "f5f88793dcba112448f2c6d0dcdfaecb650087d723e488b3c0d41e72af8a3535" => :catalina
    sha256 "54dd71344356b49404549ebcb468c7c072e586b5c6cd3f90300f094545a6c540" => :mojave
    sha256 "f52b2b0cd334a513e33ba70feb1a7e50ec36aa178ad350b199fab156d4960747" => :high_sierra
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lerna --version")

    output = shell_output("#{bin}/lerna init --independent 2>&1")
    assert_match "lerna success Initialized Lerna files", output
  end
end
