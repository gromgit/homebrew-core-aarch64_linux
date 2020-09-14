require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-2.63.0.tgz"
  sha256 "411f6dfb1fef67be5a7a1ece06492b4c74c0702889c6030827f86b0fa3dc7cb7"
  license "MIT"
  head "https://github.com/netlify/cli.git"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "844c8c0ca4ebf01f1cdfa86c4a338767c876bdb9c07dcb70d8d2760e3a073f17" => :catalina
    sha256 "a4764f018e2c373749f4c560a8adce0f2af8fea424d7eb3e675697f2d75ccc32" => :mojave
    sha256 "3d96a0bea8038c1af978b6f6547f80416adb4101c9b8ae229d02a1454454440f" => :high_sierra
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
