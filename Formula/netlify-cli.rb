require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-12.0.5.tgz"
  sha256 "2efcba20ed700d7fe3d6d5d31e0e56b86df01aab86833594c100aac10e80ab40"
  license "MIT"
  head "https://github.com/netlify/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1ef950d449611eb4915086ac6262c1c2ec5e0dd5cb1fc6356d77a5a3222544e2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1ef950d449611eb4915086ac6262c1c2ec5e0dd5cb1fc6356d77a5a3222544e2"
    sha256 cellar: :any_skip_relocation, monterey:       "8238cda40ffc43c7c2da7d37119593c4556cc4a36d650132d360d76b6336bdfb"
    sha256 cellar: :any_skip_relocation, big_sur:        "8238cda40ffc43c7c2da7d37119593c4556cc4a36d650132d360d76b6336bdfb"
    sha256 cellar: :any_skip_relocation, catalina:       "8238cda40ffc43c7c2da7d37119593c4556cc4a36d650132d360d76b6336bdfb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f8b82ea0d1e00da7764bc5bf17633d448ced69679088391474717599a9b358fe"
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
