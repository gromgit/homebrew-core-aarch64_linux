require "language/node"

class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-8.16.2.tgz"
  sha256 "c3c7fd30ee57ab1997a55ac63d4d867469d7f663dad778cd469fb7175c422f42"
  license "MIT"
  head "https://github.com/firebase/firebase-tools.git"

  livecheck do
    url :stable
  end

  bottle do
    sha256 "8819306dad4ebb8545015ebb815ec7d7ffa5557f85839395ac2928f14f5b7cbf" => :catalina
    sha256 "350b1e8a60b8283e16211e56c12b168db07421906d3bbd44e36ffd0cce43e88a" => :mojave
    sha256 "14805a132f1a75e3c8ec04120d3953fd1c91f63c39c848f8d19a2ebf71710416" => :high_sierra
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
