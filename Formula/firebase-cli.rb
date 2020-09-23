require "language/node"

class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-8.11.0.tgz"
  sha256 "7390ede247f9c44f957a9eadb85a5a925fbbe9de2b49970875714bfb9638d658"
  license "MIT"
  head "https://github.com/firebase/firebase-tools.git"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "782655a00bf67f61ae55f32861c5289be949ab42d23690275d7aab79582fbd07" => :catalina
    sha256 "16675fffa758ddb569bf7491221c9059efc3ec91fe5a2328fff62271c485b890" => :mojave
    sha256 "70368ff159db3734abb9c62f096cb05cce19fa176419e97257e5997707039905" => :high_sierra
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
