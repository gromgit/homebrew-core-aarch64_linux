require "language/node"

class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-11.14.3.tgz"
  sha256 "69c2818e70da6f9ebdd7bf10dd08fce3dc90c4381a8ee9132bfad2e3a337b687"
  license "MIT"
  head "https://github.com/firebase/firebase-tools.git", branch: "master"

  bottle do
    sha256                               arm64_monterey: "b8689d63a3877f42c8e6e7e92285239052a661648a15f93a913265b2d8643a8e"
    sha256                               arm64_big_sur:  "b0382a197622e09ef781f111d9acc931a3465744ac7e2599d95479ea449b2adb"
    sha256 cellar: :any_skip_relocation, monterey:       "bb272a795934ada3339a59a73ed9f2b7bad5d88b173be73e2c1e302acd68c806"
    sha256 cellar: :any_skip_relocation, big_sur:        "bb272a795934ada3339a59a73ed9f2b7bad5d88b173be73e2c1e302acd68c806"
    sha256 cellar: :any_skip_relocation, catalina:       "bb272a795934ada3339a59a73ed9f2b7bad5d88b173be73e2c1e302acd68c806"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3be1292e5d98306b04a7eb1b9d102961d8a4910807c4bae3beb51935f63d4739"
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
