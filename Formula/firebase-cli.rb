require "language/node"

class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-8.19.0.tgz"
  sha256 "d2ff826dae76f9b9f78ddf81d4041354d38a55bfd45b867769e40b9fb02774a4"
  license "MIT"
  head "https://github.com/firebase/firebase-tools.git"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "d5dfddc946be8eb568cca4f4ef4f85dfaae3e72dcbc1726da8ed1385a501c679" => :big_sur
    sha256 "177cdd5283285c331e19b0d6ab96c7f813b1d0595c428c70a2039cfcae4dd78c" => :catalina
    sha256 "e48269f274126e0aa1134dc5b1eb0a0d8c89def6c4f5adc2b8064232dd861b51" => :mojave
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
