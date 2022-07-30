require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-10.13.0.tgz"
  sha256 "7d8b5293767cc28e17d2e63456005e1dab654b6a3ab2a538d72747faa5a3c722"
  license "MIT"
  head "https://github.com/netlify/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "86fbfb6789b08c202db324256848395d167c1b7380b3fab0d6410ae7c6f56a33"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "86fbfb6789b08c202db324256848395d167c1b7380b3fab0d6410ae7c6f56a33"
    sha256 cellar: :any_skip_relocation, monterey:       "09c07a23a77038094da0bf355f31f8908a59310c33a6e8a093a7fc08e2cde384"
    sha256 cellar: :any_skip_relocation, big_sur:        "09c07a23a77038094da0bf355f31f8908a59310c33a6e8a093a7fc08e2cde384"
    sha256 cellar: :any_skip_relocation, catalina:       "09c07a23a77038094da0bf355f31f8908a59310c33a6e8a093a7fc08e2cde384"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7697df185b694c13ee28eb762d6da942ba59cac6771dcb57ffd9d1909ba3f34d"
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
