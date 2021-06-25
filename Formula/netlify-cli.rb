require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-3.38.10.tgz"
  sha256 "ae81496f8348bfda1d11accc78807d328d4592977cb9eef4d6a453a9c201d742"
  license "MIT"
  head "https://github.com/netlify/cli.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "074b9e3bf923cfe93202c1986f4827eb40c2f42b688ab6d9848c6f3261248e02"
    sha256 cellar: :any_skip_relocation, big_sur:       "4d53326b88c278ca0c1ae4bdcbc0589cf297c0a6f61ca1bb49ef02f22e8266f0"
    sha256 cellar: :any_skip_relocation, catalina:      "4d53326b88c278ca0c1ae4bdcbc0589cf297c0a6f61ca1bb49ef02f22e8266f0"
    sha256 cellar: :any_skip_relocation, mojave:        "4d53326b88c278ca0c1ae4bdcbc0589cf297c0a6f61ca1bb49ef02f22e8266f0"
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
