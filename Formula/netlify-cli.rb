require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-10.9.0.tgz"
  sha256 "9e13150f2e637417abefd54cdc871d0418278054962af9603a97d92e890863b1"
  license "MIT"
  head "https://github.com/netlify/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e9b74c5bb4d778889325514f22e4bff68828a1cd8afcc8214678608c79cf6709"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e9b74c5bb4d778889325514f22e4bff68828a1cd8afcc8214678608c79cf6709"
    sha256 cellar: :any_skip_relocation, monterey:       "fbce0acb9c720480c6cede4a1ee1c2e9e09580bb0ab2155f290476713886a2f9"
    sha256 cellar: :any_skip_relocation, big_sur:        "fbce0acb9c720480c6cede4a1ee1c2e9e09580bb0ab2155f290476713886a2f9"
    sha256 cellar: :any_skip_relocation, catalina:       "fbce0acb9c720480c6cede4a1ee1c2e9e09580bb0ab2155f290476713886a2f9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8aeff9a6d2596914337dda7d5e45bcb1b71046852f9ea4cdbebe7023f5285c83"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match "Not logged in. Please log in to see site status.", shell_output("#{bin}/netlify status")
  end
end
