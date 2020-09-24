require "language/node"

class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-1.4.36.tgz"
  sha256 "973ce7778c236c7024b5763c66811ce54953aeb717ea50901d4b377488b7f582"
  license "MIT"
  head "https://github.com/contentful/contentful-cli.git"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "a1553c0fb395295ac1b6fb0b56c200021f721521daa63ffe07098a5a8f85abdf" => :catalina
    sha256 "ee9923de469c6e3bd1bbd5d0e12cf5962480a3618852497f427e32435865b0d6" => :mojave
    sha256 "1790a7fadb981664d12a63db15c9cb92aaf5614f89f978e9d7a9cfea687c30be" => :high_sierra
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
