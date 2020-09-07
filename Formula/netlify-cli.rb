require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-2.61.2.tgz"
  sha256 "5d05b9e5a963c6e63effa94ee49a4eaef716f1b10ad92630900282d478eb0781"
  license "MIT"
  head "https://github.com/netlify/cli.git"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "59eec9c02e762f7d50829c945ea22d4ff2f281e658772fd0d17635f40482d326" => :catalina
    sha256 "560a86417e76c8ec050bb653790ad1039b1019f9f34491209924d15dddc49ee1" => :mojave
    sha256 "827a940a15fed70cc092ec093d35b2aa2a81d9de911067990d5160b840481e48" => :high_sierra
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
