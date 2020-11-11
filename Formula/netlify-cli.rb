require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-2.68.4.tgz"
  sha256 "75b3361be495428880ac01d89982b9ea38ab19b485af346022b72b4bf3aec90f"
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
