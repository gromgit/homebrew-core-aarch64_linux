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
    sha256 "f7559f317417e7c4f590d06e0353712d260f869a58bd27e9637d76c07eb06648" => :catalina
    sha256 "e5c35a95d8799056762cd0cd7a0fab3cdee4d81391949b4fb9350665c5fbe3d4" => :mojave
    sha256 "e2594b82800283bbc8413a42f31b95c4ba020a6887d6026019f1e5a1cf1571df" => :high_sierra
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
