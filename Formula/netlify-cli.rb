require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-2.68.5.tgz"
  sha256 "3f75954293d4a79eb8d8ca90a30a79d2abc9f57cfe3101dc19bc8b97e60440cc"
  license "MIT"
  head "https://github.com/netlify/cli.git"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "fb4a7f3b3c5a22845bf6008d4f2093938eaf18281ccc50f22849e28a7752918b" => :catalina
    sha256 "18fc3b970841d85a722885e925eb2b42cf76ded21ed9921e14c9189d50c745bb" => :mojave
    sha256 "b7f34f27af997efa8b2367d3e5ef57641ca01548efb01eceeb114fdc71f5bbfd" => :high_sierra
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
