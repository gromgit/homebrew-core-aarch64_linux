require "language/node"

class BalenaCli < Formula
  desc "The official balena CLI tool"
  homepage "https://www.balena.io/docs/reference/cli/"
  # balena-cli should only be updated every 10 releases on multiples of 10
  url "https://registry.npmjs.org/balena-cli/-/balena-cli-12.3.0.tgz"
  sha256 "9457e671e3bbeb114b6abfdf4323848a5fd1c4e9616fd8865079dd5bc93594c8"

  bottle do
    sha256 "f70852ef533bd566f3c330ac77e971a5898b24952b8233879884c99f0d424770" => :catalina
    sha256 "092679388036915200db9f73ce6396c04649ca1ee60f45e3a2b22e75e969f67c" => :mojave
    sha256 "bf22c13c44066d0aa5c94df2513010279afc3474f0e915de9f641336d4de0696" => :high_sierra
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
