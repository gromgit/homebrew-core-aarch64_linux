require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-2.51.0.tgz"
  sha256 "95a3b4ecfd5e6f61479b42e5669cf692038341bceeac2c52d85dfba3863715fd"
  head "https://github.com/netlify/cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "6d36004db2e924c2a81bd71a32ec11ba4499f27b47bbe5e52b2396bd5c7883bc" => :catalina
    sha256 "16529fd384f05d77e7159284c87f91a5d254216fea88a7b1c5838386d992fe22" => :mojave
    sha256 "56cd0daaa8c5ce7bca53e0b9f103568d4945cbd3a8089e4c5b42dcb8e5d2331e" => :high_sierra
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
