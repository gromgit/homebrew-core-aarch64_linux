require "language/node"

class BalenaCli < Formula
  desc "The official balena CLI tool"
  homepage "https://www.balena.io/docs/reference/cli/"
  # Frequent upstream releases, do not update more than once a week
  url "https://registry.npmjs.org/balena-cli/-/balena-cli-12.1.12.tgz"
  sha256 "adb9adb36ee9b21b2915eac4f7ad7cd6a32077840cd6e528fa2d9d8d7f908394"

  bottle do
    sha256 "121dd87e69e4831a7d50d12d2f80a7d504628be025d1e80fe2ed6e4c646ae706" => :catalina
    sha256 "12c0054c6cea128affc15d3907a7ef9cc2cfb9110bbf4226077758d98a579483" => :mojave
    sha256 "3d6b5858fcdc6682fab2348822322a731da14f64e9a6c01828d39158924d7238" => :high_sierra
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
