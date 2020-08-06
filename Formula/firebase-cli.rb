require "language/node"

class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-8.7.0.tgz"
  sha256 "67dd2822a8b9aeec1a3a7e32e1ffdd6c422c0ebbd8c7826e1d375530c404c806"
  license "MIT"
  head "https://github.com/firebase/firebase-tools.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "0867f98837f6b4713611c61d91662207468075cb81a629e546e49142f975aaab" => :catalina
    sha256 "1d6167ba60203a6287ae591a1ed55f27437375c7a92c514831e74da05b1d4387" => :mojave
    sha256 "18a5d244b30766249c863aff38fe61474501646bc377c241c8104f2a522d39ee" => :high_sierra
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
