require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-2.68.7.tgz"
  sha256 "d87415b85d267d6100c67cb5cb026df418ca046024d7200faf7c6582e7e60678"
  license "MIT"
  head "https://github.com/netlify/cli.git"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "cb5c61e7475adc2e62ec67f6b3f7f964abdf6d8c46edecff2888854e5fbe1266" => :big_sur
    sha256 "1047bf8f2b338525d9e478fb2cb9bb25d49cf2941156006b26000f693158efae" => :catalina
    sha256 "c0cc98cbf2648fe77d1feadd2477cbf89f5fe2f2fbeb62d3793c33c357d397f4" => :mojave
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
