require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-2.63.3.tgz"
  sha256 "ce8be771d22c5e66baa3ba4151ec8a00814816e042d794b106526fb9b053582b"
  license "MIT"
  head "https://github.com/netlify/cli.git"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "5421effde400c98e4d76a00386b03c7db617ce0c4e30de93709452e92e428f27" => :catalina
    sha256 "17e542f6b6ef91a55eab64e48eca2c0b7d12b18b5f2b7cc41f36ef5d35d8156a" => :mojave
    sha256 "111228131dbdc2f824123404a56b26e5df92cf5d24fd38b442f175c72feaadc3" => :high_sierra
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
