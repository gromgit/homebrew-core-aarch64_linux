require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-3.10.3.tgz"
  sha256 "c4bafae26e2c4c5c75cba41a16d829165d491033575b4b8989635e4ca0dcb404"
  license "MIT"
  head "https://github.com/netlify/cli.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "e7dde729b8b12fa8238ab445ed11d46389db985ed938c73369412775395f4224"
    sha256 cellar: :any_skip_relocation, big_sur:       "53edf624feb7f235f8a324476b584fe1bc93d98fcd4ac08eca934dd23fb7a9b2"
    sha256 cellar: :any_skip_relocation, catalina:      "52fede342705d3771578c0b33a324ec178033d12c47a0bb3cb10083029d922e8"
    sha256 cellar: :any_skip_relocation, mojave:        "9bbf23f4487f51db17f1195f81d87be847769767ecdcecac641293a908182ece"
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
