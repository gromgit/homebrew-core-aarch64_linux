require "language/node"

class Nativefier < Formula
  desc "Wrap web apps natively"
  homepage "https://github.com/nativefier/nativefier"
  url "https://registry.npmjs.org/nativefier/-/nativefier-45.0.6.tgz"
  sha256 "2c56fd89067cf44ee15c9952976f6b2e46a27a1051599ba20207545229f812ca"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3f4028faab54472ab0646ef3128f24445c50c055ca816fb942cd3bcd1ad1d2f4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3f4028faab54472ab0646ef3128f24445c50c055ca816fb942cd3bcd1ad1d2f4"
    sha256 cellar: :any_skip_relocation, monterey:       "5e7611a421a65cf462f4285562a12be72a3f6553b49a1cf39e3eea1c1fa1cb7e"
    sha256 cellar: :any_skip_relocation, big_sur:        "5e7611a421a65cf462f4285562a12be72a3f6553b49a1cf39e3eea1c1fa1cb7e"
    sha256 cellar: :any_skip_relocation, catalina:       "5e7611a421a65cf462f4285562a12be72a3f6553b49a1cf39e3eea1c1fa1cb7e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3f4028faab54472ab0646ef3128f24445c50c055ca816fb942cd3bcd1ad1d2f4"
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
