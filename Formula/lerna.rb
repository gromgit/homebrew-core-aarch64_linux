require "language/node"

class Lerna < Formula
  desc "Tool for managing JavaScript projects with multiple packages"
  homepage "https://lerna.js.org"
  url "https://registry.npmjs.org/lerna/-/lerna-3.22.1.tgz"
  sha256 "77a036b03fafd7a6915ef32ad9e0f5cb1950ae8c86ee27fa886e2e1bad4004ac"

  bottle do
    cellar :any_skip_relocation
    sha256 "c25015a0f199ab575092e15bb9b8539ed6b624c3c97799b3926d3504d026807e" => :catalina
    sha256 "2968bb8470488c78d9fa5a7551b5c148d49a09faf90fe91acee69fee862fa73e" => :mojave
    sha256 "8c900c2a1b0a1d6c7cefee59c9d18854014cd099bc5dd03f5a719439a363bde5" => :high_sierra
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
