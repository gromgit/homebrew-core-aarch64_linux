require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-10.8.0.tgz"
  sha256 "74d027cc353e2ce39d2e52e4fbadd7ea639317601a8596be85705e8ce64aff58"
  license "MIT"
  head "https://github.com/netlify/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "53fc1d0d692923ce347fbc0f718f9e80014faa1ce62e01e330ada22b7dd7c4a1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "53fc1d0d692923ce347fbc0f718f9e80014faa1ce62e01e330ada22b7dd7c4a1"
    sha256 cellar: :any_skip_relocation, monterey:       "934e95c0b4d6263910456b0432de2b5fa4e16d137c6c83769942e58ec7c5187f"
    sha256 cellar: :any_skip_relocation, big_sur:        "934e95c0b4d6263910456b0432de2b5fa4e16d137c6c83769942e58ec7c5187f"
    sha256 cellar: :any_skip_relocation, catalina:       "934e95c0b4d6263910456b0432de2b5fa4e16d137c6c83769942e58ec7c5187f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ccfd609aab68e1768066d9f84f624167f72fb16671663e4e1f432a6bb6ae9b98"
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
