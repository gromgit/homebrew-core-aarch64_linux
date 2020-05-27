require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-2.52.0.tgz"
  sha256 "b82c9bc99a7d63230f01c297fee438aad85daa78d7812e5fab0d8937b4712688"
  head "https://github.com/netlify/cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "1f7b22118675800a261ecbc700ce6c7fcbead8d4fc5936dbbb41c752c48c8b8d" => :catalina
    sha256 "83debba04cd805897394271578ee570f7c8a6d79a7f0564e72947d5f1bdee2d2" => :mojave
    sha256 "8cb0fc6e7533194c01255430ea915fdfacf873c89a0471db12eae11e8a348bb5" => :high_sierra
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
