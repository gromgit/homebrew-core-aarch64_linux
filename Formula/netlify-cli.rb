require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-10.17.5.tgz"
  sha256 "865dafeb0b59a4506a2b2ea0fe9cebe23dd33b041a7f93ab6e874dd021a937a8"
  license "MIT"
  head "https://github.com/netlify/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0615fd13403ba14bdfed61cd10c1bf1d6c561ad48086b9d705b766a1b69062e3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0615fd13403ba14bdfed61cd10c1bf1d6c561ad48086b9d705b766a1b69062e3"
    sha256 cellar: :any_skip_relocation, monterey:       "09e48d8f10b0aee3d5e3aefb33529864a345497068da4eacdf8608a19799b3f2"
    sha256 cellar: :any_skip_relocation, big_sur:        "09e48d8f10b0aee3d5e3aefb33529864a345497068da4eacdf8608a19799b3f2"
    sha256 cellar: :any_skip_relocation, catalina:       "09e48d8f10b0aee3d5e3aefb33529864a345497068da4eacdf8608a19799b3f2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f54b1ba98915b30d292301cf9a5310428b594570ce59e3d7b32b790cdf764858"
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
