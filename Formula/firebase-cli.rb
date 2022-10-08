require "language/node"

class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-11.14.1.tgz"
  sha256 "bfde4a2e041e412671f4664ea413110950b92b8ae5674269adfb3f142027beda"
  license "MIT"
  head "https://github.com/firebase/firebase-tools.git", branch: "master"

  bottle do
    sha256                               arm64_monterey: "56a93302be02a6f3187f55d81904dfc1a0a80984405722b411846b6454e2fc89"
    sha256                               arm64_big_sur:  "ec164fc031ddf4b5e1cec31b8a502fe14871f816cef1980c7e8eceb5cc3fed4c"
    sha256 cellar: :any_skip_relocation, monterey:       "c90f5ef2d47844466b866ad13fd84ec7b539f295f6046a242553415427a14f4e"
    sha256 cellar: :any_skip_relocation, big_sur:        "c90f5ef2d47844466b866ad13fd84ec7b539f295f6046a242553415427a14f4e"
    sha256 cellar: :any_skip_relocation, catalina:       "c90f5ef2d47844466b866ad13fd84ec7b539f295f6046a242553415427a14f4e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3cac9f89e7bf3834d4565a3013d5e90f7b56d3e751e0edfd8920b795edd97276"
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
