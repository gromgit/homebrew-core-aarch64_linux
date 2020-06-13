require "language/node"

class BalenaCli < Formula
  desc "The official balena CLI tool"
  homepage "https://www.balena.io/docs/reference/cli/"
  # Frequent upstream releases, do not update more than once a week
  url "https://registry.npmjs.org/balena-cli/-/balena-cli-11.36.0.tgz"
  sha256 "6cbbf3e8db2f9abe9c86a259cb6da707b10c09a70b00e3db454320c460bec1ce"

  bottle do
    sha256 "cecfa211256d0b1afc20e6e4f4ab53decc8540ee6136064d5b36e391ac9374fb" => :catalina
    sha256 "d74dd96103a951c1fc71923f61ddc1d8d9b711ffd6c68566972ce4b759fef5e4" => :mojave
    sha256 "373c98f1c07b15f6d080575fb60fb78a4cb096b1ee8e91bb12e59f182cc1a1c3" => :high_sierra
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
