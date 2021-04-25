require "language/node"

class Gitmoji < Formula
  desc "Emoji guide for your commit messages"
  homepage "https://gitmoji.carloscuesta.me"
  url "https://registry.npmjs.org/gitmoji-cli/-/gitmoji-cli-3.4.1.tgz"
  sha256 "40d372cc3c7ced144947cf3cd9c5c20936efba8d09d582c4219c5648aa0bfbed"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "1728e50ec13dbea620ea340de1c038ec8656deac39c9331c90114110aef12c3c"
    sha256 cellar: :any_skip_relocation, big_sur:       "cf2d88c2b095c93bd5f500cba429a8f9185d50d057da2097e4a0c53d3b60a10e"
    sha256 cellar: :any_skip_relocation, catalina:      "cf2d88c2b095c93bd5f500cba429a8f9185d50d057da2097e4a0c53d3b60a10e"
    sha256 cellar: :any_skip_relocation, mojave:        "ea1c923f959f56091ad72ad38d3d3bbf9f63e85dbd444c5af647f851a962882f"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match ":bug:", shell_output("#{bin}/gitmoji --search bug")
  end
end
