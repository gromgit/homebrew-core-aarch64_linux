require "language/node"

class BalenaCli < Formula
  desc "Command-line tool for interacting with the balenaCloud and balena API"
  homepage "https://www.balena.io/docs/reference/cli/"
  # balena-cli should only be updated every 10 releases on multiples of 10
  url "https://registry.npmjs.org/balena-cli/-/balena-cli-12.23.0.tgz"
  sha256 "c90e4a66701debb81c24d8d6442d19de072710c100ef6e96c9454d8245b2ece2"
  license "Apache-2.0"

  livecheck do
    url :stable
  end

  bottle do
    sha256 "64c18bc02693145fdf339a86091b2c8081e489ad695444b13b4ded459abcfc28" => :catalina
    sha256 "c9132974c680709d6abc72748daff8e8a43c6975d8d926f7fc8a605a5b5ae0c6" => :mojave
    sha256 "ccf55cbdb92b95e72b7e4d4d843736d71a59be0c08e48660d704c44e0c26f504" => :high_sierra
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
