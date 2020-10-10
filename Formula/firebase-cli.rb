require "language/node"

class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-8.12.1.tgz"
  sha256 "b744fa014025d9fd12197399895f0e364383ef0505809903ac45896175e40b15"
  license "MIT"
  head "https://github.com/firebase/firebase-tools.git"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "b250ab828ed7344ec4d1c0928df3d6f585a4b9799ba3faa87e95536503c4589c" => :catalina
    sha256 "1267c3428431fe1b3bb621290fb53a26b8843c9c959ffe0f057a11cac24173e0" => :mojave
    sha256 "08fdbff9348a87ecbe485c7aa2c60f15dd2bd54690c4bf4e8b7530770984ba8d" => :high_sierra
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
