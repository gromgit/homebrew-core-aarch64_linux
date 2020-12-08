require "language/node"

class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-8.18.0.tgz"
  sha256 "538ba94264bcf4e9dea933568dd2381523c7b2a3113de8420a25de97490ba93b"
  license "MIT"
  head "https://github.com/firebase/firebase-tools.git"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "362d2ad76d8bf4166dad897f0febd6a6a1693b411c47d8fb62057133a759858e" => :big_sur
    sha256 "925b4242499910eb9d415f2e80abd5e4bc77ba710c86846c9547c116b9690549" => :catalina
    sha256 "96ff650ef7516a89184a08098fdfc9ae0cd0f1d800d3548591b67e0d31541828" => :mojave
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
