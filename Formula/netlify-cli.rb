require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-11.0.0.tgz"
  sha256 "56af6acf135d31e73c9639ff866c2d0dfa325cabd4d7ea6a2151d97eb889283d"
  license "MIT"
  head "https://github.com/netlify/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0043260b8702347825113b445cc37d0d6b1449503e6219fda3bc1208da6126f7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0043260b8702347825113b445cc37d0d6b1449503e6219fda3bc1208da6126f7"
    sha256 cellar: :any_skip_relocation, monterey:       "20eb2029ffa780019673e0fdd91c004cc77f3845788f7ff16f5585bc169fba15"
    sha256 cellar: :any_skip_relocation, big_sur:        "20eb2029ffa780019673e0fdd91c004cc77f3845788f7ff16f5585bc169fba15"
    sha256 cellar: :any_skip_relocation, catalina:       "20eb2029ffa780019673e0fdd91c004cc77f3845788f7ff16f5585bc169fba15"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "880bb156e1b1dad6590d3b9b334651434fddc640f6b51b5dc9820ac4d7e497ba"
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
