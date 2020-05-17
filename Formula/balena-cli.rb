require "language/node"

class BalenaCli < Formula
  desc "The official balena CLI tool"
  homepage "https://www.balena.io/docs/reference/cli/"
  # Frequent upstream releases, do not update more than once a week
  url "https://registry.npmjs.org/balena-cli/-/balena-cli-11.35.1.tgz"
  sha256 "2001b766415312723d0f556f7456b931983376f67ee338123a8623caf50e15f4"

  bottle do
    sha256 "b2cfc1ec97208713102dfedc6b625c3b1551c37d0c050e168b0589900a109ed7" => :catalina
    sha256 "d52f29aac4be49ceb2c3b8f2ae7734e1a9e6c94dfc459722c4c31bffd56d7cd0" => :mojave
    sha256 "c4d02c86f5d36eee0cafd6e82651046fc724edd5e4a442bd8085bb1520cf1e51" => :high_sierra
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
