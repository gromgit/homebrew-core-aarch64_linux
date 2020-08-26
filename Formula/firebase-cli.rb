require "language/node"

class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-8.9.1.tgz"
  sha256 "2f3a731d4b15ea7827e7f9a150ac2fa55fa02dbd51252e397afbc56c54a0484e"
  license "MIT"
  head "https://github.com/firebase/firebase-tools.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "a231b8f5fd27cb2bf77f64c0fed9dca095d2297b57a87d72640a89e24a610dfa" => :catalina
    sha256 "101ce557b1add858585e501d56bbe9ecde3c6daa9c04ee3bbbfa14da43324105" => :mojave
    sha256 "b775fbdc084a6306fa6a56700e4494255fcd8a7646859f12e330d99d1167ba33" => :high_sierra
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
