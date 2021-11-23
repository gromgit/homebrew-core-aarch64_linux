require "language/node"

class Nativefier < Formula
  desc "Wrap web apps natively"
  homepage "https://github.com/nativefier/nativefier"
  url "https://registry.npmjs.org/nativefier/-/nativefier-45.0.6.tgz"
  sha256 "2c56fd89067cf44ee15c9952976f6b2e46a27a1051599ba20207545229f812ca"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5ff315eaecd82eae1478d0b72ebf6a6db93e98762cec28986a41365aded6d300"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5ff315eaecd82eae1478d0b72ebf6a6db93e98762cec28986a41365aded6d300"
    sha256 cellar: :any_skip_relocation, monterey:       "ae009def671e5054a1af48325099b638065b85f91332e5b78a3a6a2c55f0b738"
    sha256 cellar: :any_skip_relocation, big_sur:        "ae009def671e5054a1af48325099b638065b85f91332e5b78a3a6a2c55f0b738"
    sha256 cellar: :any_skip_relocation, catalina:       "ae009def671e5054a1af48325099b638065b85f91332e5b78a3a6a2c55f0b738"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5ff315eaecd82eae1478d0b72ebf6a6db93e98762cec28986a41365aded6d300"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/nativefier --version")
  end
end
