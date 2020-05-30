require "language/node"

class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-8.4.1.tgz"
  sha256 "dfc15bfb0710069e460a34c3df0401ecfef6e1bb2bb1da0795d7284be870a0c3"
  head "https://github.com/firebase/firebase-tools.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "918e6bd78ec3c7cad78b4224366ecc0d5ca50d16090a33998c30fcbb1bfe6bd1" => :catalina
    sha256 "fb8fc427a321bba89d4c6c2c07d0bb01af72b6989ce49002b41d98e0b1cda31e" => :mojave
    sha256 "9b0cf30883887186c3f5e0b51511d94ddd5e8aa43907b849979d398ebee574a1" => :high_sierra
  end

  depends_on "node"

  uses_from_macos "expect" => :test

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"test.exp").write <<~EOS
      spawn #{bin}/firebase login:ci --no-localhost
      expect "Paste"
    EOS
    assert_match "authorization code", shell_output("expect -f test.exp")
  end
end
