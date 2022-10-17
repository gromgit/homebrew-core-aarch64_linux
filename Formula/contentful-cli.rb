require "language/node"

class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-1.15.25.tgz"
  sha256 "3771d5ea3a02476d24b73c3c58ff2468477b08e7098e542f60094ad4cd49b596"
  license "MIT"
  head "https://github.com/contentful/contentful-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6d53e1839f4511c0599eca98ce7a98faf976acfda9092b05ffdb1eddbfd77f1e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6d53e1839f4511c0599eca98ce7a98faf976acfda9092b05ffdb1eddbfd77f1e"
    sha256 cellar: :any_skip_relocation, monterey:       "1a8cce4b18569859a265cae813c193aa5869e76dea0f3e5f4f43a422c2787cd1"
    sha256 cellar: :any_skip_relocation, big_sur:        "1a8cce4b18569859a265cae813c193aa5869e76dea0f3e5f4f43a422c2787cd1"
    sha256 cellar: :any_skip_relocation, catalina:       "1a8cce4b18569859a265cae813c193aa5869e76dea0f3e5f4f43a422c2787cd1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6d53e1839f4511c0599eca98ce7a98faf976acfda9092b05ffdb1eddbfd77f1e"
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
