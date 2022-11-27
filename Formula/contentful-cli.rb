require "language/node"

class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-1.12.25.tgz"
  sha256 "824e900b543128b8cc8f59794b1856ad0e896e6850c3ae8778c1cc06e02a8d09"
  license "MIT"
  head "https://github.com/contentful/contentful-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ac68ba5dee553cd65dbd10672816e0404d0907e86d99addcd1ce96ece9d5d843"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ac68ba5dee553cd65dbd10672816e0404d0907e86d99addcd1ce96ece9d5d843"
    sha256 cellar: :any_skip_relocation, monterey:       "e57b4c01abd0c9e8449754893f975f541f34cf2a7923ebe9987cd3240c2af5e2"
    sha256 cellar: :any_skip_relocation, big_sur:        "e57b4c01abd0c9e8449754893f975f541f34cf2a7923ebe9987cd3240c2af5e2"
    sha256 cellar: :any_skip_relocation, catalina:       "e57b4c01abd0c9e8449754893f975f541f34cf2a7923ebe9987cd3240c2af5e2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ac68ba5dee553cd65dbd10672816e0404d0907e86d99addcd1ce96ece9d5d843"
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
