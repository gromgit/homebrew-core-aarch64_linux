require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-2.61.3.tgz"
  sha256 "d0dffe4188c41079a1d6d2a2da873ef10938b9904e74e27f1abb76e33b0b43fa"
  license "MIT"
  head "https://github.com/netlify/cli.git"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "4307f4d515052896a2d139851165c01accf6784148787d09d0c2c87ed8e8023b" => :catalina
    sha256 "7287d8c8243fc7166bb024d34407221336cb95d0d7f861a7eac24fc6f76fab91" => :mojave
    sha256 "5412f6c7a24641ad2e86290faa3fe40cbf0eeaafe7a4dbbe14f73646ba618cd6" => :high_sierra
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
