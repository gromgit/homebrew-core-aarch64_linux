require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-10.2.0.tgz"
  sha256 "751180b80474e457765c5968de019a76dc023b5d397acf1098da0373749af11b"
  license "MIT"
  head "https://github.com/netlify/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3091ec7f394360040c6e6f8fb60aa37e86ac18336d4d51a7a040cab1d50218ff"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3091ec7f394360040c6e6f8fb60aa37e86ac18336d4d51a7a040cab1d50218ff"
    sha256 cellar: :any_skip_relocation, monterey:       "148a6884b0ad91f06806f82708ac4d9cd11d7e42a8a09763554a836577bbc92a"
    sha256 cellar: :any_skip_relocation, big_sur:        "148a6884b0ad91f06806f82708ac4d9cd11d7e42a8a09763554a836577bbc92a"
    sha256 cellar: :any_skip_relocation, catalina:       "148a6884b0ad91f06806f82708ac4d9cd11d7e42a8a09763554a836577bbc92a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7ebc5aca99aa48ecf21d621d8608a934f990816bf9352d79ed1a0fab9121fade"
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
