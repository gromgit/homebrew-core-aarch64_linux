require "language/node"

class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-9.14.0.tgz"
  sha256 "b7a8bb6fdf05aeb61e1aaa3a9852654075f6fd0b0f605270f049478c2f2be5a1"
  license "MIT"
  head "https://github.com/firebase/firebase-tools.git"

  bottle do
    sha256                               arm64_big_sur: "06755d5246846d03fd4991882f1cf18b2d4751aa6451e746ae86f9fe77923a3a"
    sha256 cellar: :any_skip_relocation, big_sur:       "696b777ae7f30fa803aff011b7431e35d1baef59f9957f34c36504e17e92da25"
    sha256 cellar: :any_skip_relocation, catalina:      "696b777ae7f30fa803aff011b7431e35d1baef59f9957f34c36504e17e92da25"
    sha256 cellar: :any_skip_relocation, mojave:        "696b777ae7f30fa803aff011b7431e35d1baef59f9957f34c36504e17e92da25"
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
