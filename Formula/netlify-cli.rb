require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-3.38.5.tgz"
  sha256 "6a52a39ebd587470a1aadb7cbe5f1f0e2ddc7cbf580c882f40e51207e64a40af"
  license "MIT"
  head "https://github.com/netlify/cli.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "076ab4ee8c31f923d1eb82509d6ab6796a6db225436150d042857b1310e2e90a"
    sha256 cellar: :any_skip_relocation, big_sur:       "18cb61f8c64d5532c82613ca9670dacd6893c4ca4666fe84871a636bfafd8623"
    sha256 cellar: :any_skip_relocation, catalina:      "18cb61f8c64d5532c82613ca9670dacd6893c4ca4666fe84871a636bfafd8623"
    sha256 cellar: :any_skip_relocation, mojave:        "18cb61f8c64d5532c82613ca9670dacd6893c4ca4666fe84871a636bfafd8623"
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
