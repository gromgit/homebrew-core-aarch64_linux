require "language/node"

class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-1.4.37.tgz"
  sha256 "a9b2d3a2184777000417530964f28030f58652c528845f52d27966be6263d898"
  license "MIT"
  head "https://github.com/contentful/contentful-cli.git"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "eb9b2049a3d425fcdb5c6dc38b1d0b134cce634654f6634da9b4a48e1d7061d8" => :catalina
    sha256 "328824c4cbea2e93aa303849f50c7a2a34a6b68683711c9b70583f3f7393be29" => :mojave
    sha256 "f580478f7f2ace39c0cf944a939c33ea69663a872b1102099be2e18a1559e1d8" => :high_sierra
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    output = shell_output("#{bin}/contentful space list 2>&1", 1)
    assert_match "🚨  Error: You have to be logged in to do this.", output
    assert_match "You can log in via contentful login", output
    assert_match "Or provide a management token via --management-token argument", output
  end
end
