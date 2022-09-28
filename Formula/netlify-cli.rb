require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-12.0.0.tgz"
  sha256 "d1ba8f32c7ad4e7caedec20f32f29b2bbd9c94a2a0918415be2cbe202de63a12"
  license "MIT"
  head "https://github.com/netlify/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0c8e98bd4dfb147009410605d59a0a14f74a37b4f36ae222f065a36ab715ad7f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0c8e98bd4dfb147009410605d59a0a14f74a37b4f36ae222f065a36ab715ad7f"
    sha256 cellar: :any_skip_relocation, monterey:       "99f5fc06404ba8048501bcae709c9a661982f2169abe364f4f4c3ca020c57895"
    sha256 cellar: :any_skip_relocation, big_sur:        "99f5fc06404ba8048501bcae709c9a661982f2169abe364f4f4c3ca020c57895"
    sha256 cellar: :any_skip_relocation, catalina:       "99f5fc06404ba8048501bcae709c9a661982f2169abe364f4f4c3ca020c57895"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "691bbc21342244a1978641f574df62e783a310336336d6392770d2aa7a2274bb"
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
