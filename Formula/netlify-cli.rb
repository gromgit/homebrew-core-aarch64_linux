require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-2.60.0.tgz"
  sha256 "bdb2511bee020a502eaaa42fda0f37769fb903b70c7f407fd556f1895ca9a3f1"
  license "MIT"
  head "https://github.com/netlify/cli.git"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "a73962af4deaaf947e877ce0209593233b0259ce853a38203dd954d9dcdd639b" => :catalina
    sha256 "3763331281d655f3ab891aa3544b6dfd5920331e1a28352caebfbd930651b29c" => :mojave
    sha256 "521e3735c0356cc36f6e2d8f306dc819c1eecf5407e590ee45db862d79a3b2f2" => :high_sierra
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
