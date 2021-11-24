require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-7.1.0.tgz"
  sha256 "eaadffc385f862b4db49678ba673fd29fd7da6b3478a74acf57042164cb2da56"
  license "MIT"
  head "https://github.com/netlify/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fdf8938db40f170cf815ef94ef0cf132bcf05061dcd84514b148994c9ef6c720"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fdf8938db40f170cf815ef94ef0cf132bcf05061dcd84514b148994c9ef6c720"
    sha256 cellar: :any_skip_relocation, monterey:       "af94ebeaf7a0ee69e9cff355caa92978eac162d50aa4c32eb1e6cc54d3177963"
    sha256 cellar: :any_skip_relocation, big_sur:        "af94ebeaf7a0ee69e9cff355caa92978eac162d50aa4c32eb1e6cc54d3177963"
    sha256 cellar: :any_skip_relocation, catalina:       "af94ebeaf7a0ee69e9cff355caa92978eac162d50aa4c32eb1e6cc54d3177963"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "10089703c3979d8f735f3803f745945e53bde046993b18408b2fa35ab4533298"
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
