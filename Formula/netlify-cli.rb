require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-2.62.0.tgz"
  sha256 "24f5908ea482bfc7fe3cacd2db50ccae7862dbd4ef2be296cab8bf66f65d6dba"
  license "MIT"
  head "https://github.com/netlify/cli.git"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "8de24dc6ccee739af17c0931a0be7ebba3230a3dc21d81cbac1f83dafb315d40" => :catalina
    sha256 "23ac7cc78838bde3c70a304f03dd431f76084a4d2516d5d9fd03c53679dcb452" => :mojave
    sha256 "bc040f00a185cef074d085937b035c3c9217b290a8b231c6e6329233b21bed69" => :high_sierra
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
