require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-10.12.0.tgz"
  sha256 "7c64bc8e550f9a9450526b60cb230199094a9d88ca809f04d7c5edc743586975"
  license "MIT"
  head "https://github.com/netlify/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "68e6b38475424e60d0f691c40c9ef3ac8eee0f6b1ae2b3928fe59593f80c1d46"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "68e6b38475424e60d0f691c40c9ef3ac8eee0f6b1ae2b3928fe59593f80c1d46"
    sha256 cellar: :any_skip_relocation, monterey:       "f809b2e77f97fbbdf2238c96fd633903ecc30137f4c233cd929e95dff5fcd00d"
    sha256 cellar: :any_skip_relocation, big_sur:        "f809b2e77f97fbbdf2238c96fd633903ecc30137f4c233cd929e95dff5fcd00d"
    sha256 cellar: :any_skip_relocation, catalina:       "f809b2e77f97fbbdf2238c96fd633903ecc30137f4c233cd929e95dff5fcd00d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "87f5410ceddd69607c7c73cbdd7c0dab76d0ca5ac58fbae43812aaaf8f2627b5"
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
