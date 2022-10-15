require "language/node"

class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-11.14.4.tgz"
  sha256 "3fd55d24f3ee6d9b7139bc54937d8f4db7259a57d85639998e3e8fb26dcca4e2"
  license "MIT"
  head "https://github.com/firebase/firebase-tools.git", branch: "master"

  bottle do
    sha256                               arm64_monterey: "6a6d1151d6d28fc9d8770da6c2a199519b44d85de264407f44a6a761a65d3f54"
    sha256                               arm64_big_sur:  "f47b77b826a449897aa742f3835dc64e515739c0844ab4ace4a52816a4714325"
    sha256 cellar: :any_skip_relocation, monterey:       "dbba8a9ea2d8385eccfe6ff626680e88293523dfc0b18836e43e136e83d12d26"
    sha256 cellar: :any_skip_relocation, big_sur:        "dbba8a9ea2d8385eccfe6ff626680e88293523dfc0b18836e43e136e83d12d26"
    sha256 cellar: :any_skip_relocation, catalina:       "dbba8a9ea2d8385eccfe6ff626680e88293523dfc0b18836e43e136e83d12d26"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a6b2b4f4f39d055fe511fd1e088d0ed98c8a365c1d151d52a2619f53251a3c01"
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
