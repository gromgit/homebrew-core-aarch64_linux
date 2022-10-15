require "language/node"

class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-11.14.4.tgz"
  sha256 "3fd55d24f3ee6d9b7139bc54937d8f4db7259a57d85639998e3e8fb26dcca4e2"
  license "MIT"
  head "https://github.com/firebase/firebase-tools.git", branch: "master"

  bottle do
    sha256                               arm64_monterey: "a4defc20fb99c9eb7d7caafc805e8419064e2c0bf88c2988eae668bc8346904c"
    sha256                               arm64_big_sur:  "77960e807d60a6f3ed07643247f18275a0fb5fb9da7be5a1bb787a581d5422e8"
    sha256 cellar: :any_skip_relocation, monterey:       "47621983a59547e37c96b65bbfef688acab43e09f2878635d9a85ee2f706174a"
    sha256 cellar: :any_skip_relocation, big_sur:        "47621983a59547e37c96b65bbfef688acab43e09f2878635d9a85ee2f706174a"
    sha256 cellar: :any_skip_relocation, catalina:       "47621983a59547e37c96b65bbfef688acab43e09f2878635d9a85ee2f706174a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6d805c65a73e170ada2d89c1c6af6c6e64a83c356de7578bb56db6fd01e0125e"
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
