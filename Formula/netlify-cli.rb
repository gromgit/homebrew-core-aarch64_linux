require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-3.10.3.tgz"
  sha256 "c4bafae26e2c4c5c75cba41a16d829165d491033575b4b8989635e4ca0dcb404"
  license "MIT"
  head "https://github.com/netlify/cli.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "6ee92581193a7d71f59fe595e4f497671457ccdb06cd687453dfa6c4276c3461"
    sha256 cellar: :any_skip_relocation, big_sur:       "7b66a4c7a956e9b3dbb1a6ceeed98f43a098cc38385cc69157ebb39c54d6d552"
    sha256 cellar: :any_skip_relocation, catalina:      "eb4b182368bf25502d530c6908cc833d9f87489d375cd8b95fcf1e906c836699"
    sha256 cellar: :any_skip_relocation, mojave:        "80e0aaf4588a720e784201b17367f05a0fa46ffcc065f4a01df194647f0c3293"
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
