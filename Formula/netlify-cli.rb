require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-2.63.1.tgz"
  sha256 "538041a89b9fb4600d9692c225084789ba3cfb9b8f1c8177408669dc58c92649"
  license "MIT"
  head "https://github.com/netlify/cli.git"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "3235ea11fa89aa3ced3f48befde14b4351ded3c9b2dd33cd4a6668a83e71baf4" => :catalina
    sha256 "d399c5a2f69f93586fde89e4ae25e65bec5a0f3ec535fb0861e62a9fa847b931" => :mojave
    sha256 "4f35b549fddb9aac353c4c257bf4d389d0d7643d5ba7ae0071ac9a5e8d27d180" => :high_sierra
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
