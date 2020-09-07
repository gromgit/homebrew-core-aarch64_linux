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
    sha256 "954d1a382025ac014529ecdf0abc8dc5bf9080238cbb6e97cc546bc431b6b78e" => :catalina
    sha256 "89b1c82d9f2376df6ac947abd5d785a67f9763dc5cde0940644aedbd89cd4f0d" => :mojave
    sha256 "e94267418f905fc41871b0f12302db9b7f1a8f303feb1699220a042693362c37" => :high_sierra
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
