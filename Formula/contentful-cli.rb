require "language/node"

class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-1.9.5.tgz"
  sha256 "16e043b7ede24a3df70c32a32ffd5495a01cfe3a7e6bbb4ad77a642ca0167287"
  license "MIT"
  head "https://github.com/contentful/contentful-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "26bab1e50d9537b9f02e64bc1dcc6e894e6db088122d3908abe706459b3a61be"
    sha256 cellar: :any_skip_relocation, big_sur:       "864ac5a640e01e1d547248dad7d4f0af351bbdfc2c066bd7394362fd3bde37d6"
    sha256 cellar: :any_skip_relocation, catalina:      "864ac5a640e01e1d547248dad7d4f0af351bbdfc2c066bd7394362fd3bde37d6"
    sha256 cellar: :any_skip_relocation, mojave:        "864ac5a640e01e1d547248dad7d4f0af351bbdfc2c066bd7394362fd3bde37d6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "47586639ce171e02656a08be67231c8ea52bffa5cc72c38d04e0c2a62c779e9c"
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
