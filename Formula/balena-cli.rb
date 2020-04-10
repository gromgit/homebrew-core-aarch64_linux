require "language/node"

class BalenaCli < Formula
  desc "The official balena CLI tool"
  homepage "https://www.balena.io/docs/reference/cli/"
  # Frequent upstream releases, do not update more than once a week
  url "https://registry.npmjs.org/balena-cli/-/balena-cli-11.30.17.tgz"
  sha256 "982ae07ff72c6882a01943f3514be7dfb3ea55f4261f9aeae8468d14b5c4f1db"

  bottle do
    sha256 "54bc1f89fc4d4d297182cad67e49b0ff26766979a7b832db37795e73d927e610" => :catalina
    sha256 "a969ccdd93d28aec0ba92e1fe2a80a0fc7c3b81ba71267eab8d5e0b66a30e998" => :mojave
    sha256 "c956a95297fdabd6e36b834b8e3bdc27a7a04d2c368438cb7aecd8f07edef7e7" => :high_sierra
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
