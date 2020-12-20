require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-2.69.11.tgz"
  sha256 "f9c12e0f604b3d05a689e72b4c4b8bb09a9752e7fcb135c15c2d41a4bc20fe73"
  license "MIT"
  head "https://github.com/netlify/cli.git"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "313656c2d74c6b09314d3aec671722f0b81600dd9d4a8f1c564501fb4221e4b0" => :big_sur
    sha256 "fc167a51e2b51a5e2a360e9715418c60479b0b28f9d2eb7ea818d8de757c8a4b" => :catalina
    sha256 "0a280c0a3c5034a8ffea88c8697ef978d714b9cfa2a41fa316c588aebc7044e5" => :mojave
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
