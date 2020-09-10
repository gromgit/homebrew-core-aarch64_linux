require "language/node"

class BalenaCli < Formula
  desc "The official balena CLI tool"
  homepage "https://www.balena.io/docs/reference/cli/"
  # balena-cli should only be updated every 10 releases on multiples of 10
  url "https://registry.npmjs.org/balena-cli/-/balena-cli-12.19.0.tgz"
  sha256 "7f182e052e9e40c0979413cb826f720b1c965da4cccbb20e3785be56f0f15ac9"
  license "Apache-2.0"

  livecheck do
    url :stable
  end

  bottle do
    sha256 "c2be2c7f66eec2ff64fe6ca3a469d95ac9d6517adec449e9b13e62827faa651a" => :catalina
    sha256 "577ed4ed34c92d1b447fa32a539514a17324acf9b6d9f479c01ef3157465b45a" => :mojave
    sha256 "3bfbfb8757b7c226a3ce1e1bfb809a9ed7e3cf53b4cc1bb7da7f2ae05876244a" => :high_sierra
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
