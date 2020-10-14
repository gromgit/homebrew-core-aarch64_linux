require "language/node"

class BalenaCli < Formula
  desc "Command-line tool for interacting with the balenaCloud and balena API"
  homepage "https://www.balena.io/docs/reference/cli/"
  # balena-cli should only be updated every 10 releases on multiples of 10
  url "https://registry.npmjs.org/balena-cli/-/balena-cli-12.25.0.tgz"
  sha256 "af78b891de5492e567d731dee62369b3d1247c262acf94d2bf4e2379790a947e"
  license "Apache-2.0"

  livecheck do
    url :stable
  end

  bottle do
    sha256 "6d891273fc1a8230c0c50f781b0f4b807128dda1d963396067d990ee86d1004a" => :catalina
    sha256 "e3081e142a85667add5b247992d4fbed38cd59db19e7108f0d5c033200194189" => :mojave
    sha256 "1bccfaa0fc5277e1542c473900ca683495b59a68f34317a2da7d3cc576f3acd1" => :high_sierra
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
