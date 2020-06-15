require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-2.54.0.tgz"
  sha256 "bd25b06744158f382b62c2b7efd213abaeafb6b56654e38e9478c5d86f684f7d"
  head "https://github.com/netlify/cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "b0cd05c94ca526708900b3a872f27628c82c3e745310ec75ed20a175c85b18d7" => :catalina
    sha256 "769ded1767e11fc7e5d2becc0817a69059e512c4efdff604236a277580ee46c8" => :mojave
    sha256 "4d20fcb1716bf4a348c88cc65fd956c4d1454ccad108fee8e3f39976e24f88da" => :high_sierra
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
