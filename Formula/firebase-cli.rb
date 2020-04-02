require "language/node"

class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-8.0.0.tgz"
  sha256 "a44a2884e6210b50486146dfaed35fde75d09d14920fbaa63d27ae2707197a09"
  head "https://github.com/firebase/firebase-tools.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "d95f86c54c8abecb71a51b8629f091209c1f4084f2374231832db7d9b6a4671d" => :catalina
    sha256 "2c05528b0732ba83448294c2546d99fe49db39073fbf27824dbca60cb8e37cce" => :mojave
    sha256 "caf5820e83b4c33be9e4d8ed076b6a8f748c9c0da755c7729b9aadaccaddb0b2" => :high_sierra
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
