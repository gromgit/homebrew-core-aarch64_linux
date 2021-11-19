require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-7.0.0.tgz"
  sha256 "cafcd7977d30f8a2772b6f70d340786e6c427f837c99f8ba8c6af0d6e4380fe4"
  license "MIT"
  head "https://github.com/netlify/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3b102b021f94ec4ba9e57d5515319c88cd5fae536cedbaced33c1c2db7b05ae5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3b102b021f94ec4ba9e57d5515319c88cd5fae536cedbaced33c1c2db7b05ae5"
    sha256 cellar: :any_skip_relocation, monterey:       "ecf76a6c5caa2793a72b07aa4cc306da9178ddd9a91a483ffcf4c420d3a73b26"
    sha256 cellar: :any_skip_relocation, big_sur:        "ecf76a6c5caa2793a72b07aa4cc306da9178ddd9a91a483ffcf4c420d3a73b26"
    sha256 cellar: :any_skip_relocation, catalina:       "ecf76a6c5caa2793a72b07aa4cc306da9178ddd9a91a483ffcf4c420d3a73b26"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "59abad85f70f368425b1f837426f53f80b10ed339296708abb19a2bb3980fc8f"
  end

  depends_on "node"

  uses_from_macos "expect" => :test

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"test.exp").write <<~EOS
      spawn #{bin}/netlify login
      expect "Opening"
    EOS
    assert_match "Logging in", shell_output("expect -f test.exp")
  end
end
