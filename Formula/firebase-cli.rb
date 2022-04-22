require "language/node"

class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-10.7.1.tgz"
  sha256 "28321d66bb502f166d3b169582ee2e70e2b9c51aa38e42a8fc80288817fd5946"
  license "MIT"
  head "https://github.com/firebase/firebase-tools.git", branch: "master"

  bottle do
    sha256                               arm64_monterey: "9fbb096b2871b79c4bc284811a1b98e238348c7912cf701d24c6971a0caaf055"
    sha256                               arm64_big_sur:  "af38804a2c4250b653735d7500a4aa2de5a58f2554664b1cd73a04a53897213c"
    sha256 cellar: :any_skip_relocation, monterey:       "841203d6cc9aaf318295c504fed1465ead075afd9b47e2bdadbb27258408aaad"
    sha256 cellar: :any_skip_relocation, big_sur:        "841203d6cc9aaf318295c504fed1465ead075afd9b47e2bdadbb27258408aaad"
    sha256 cellar: :any_skip_relocation, catalina:       "841203d6cc9aaf318295c504fed1465ead075afd9b47e2bdadbb27258408aaad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8fae6cc5be93ed0f7531bf423daffccd66fc2977e48ada04424829434f1a5a94"
  end

  depends_on "node"

  uses_from_macos "expect" => :test

  on_macos do
    depends_on "macos-term-size"
  end

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]

    term_size_vendor_dir = libexec/"lib/node_modules/firebase-tools/node_modules/term-size/vendor"
    term_size_vendor_dir.rmtree # remove pre-built binaries

    if OS.mac?
      macos_dir = term_size_vendor_dir/"macos"
      macos_dir.mkpath
      # Replace the vendored pre-built term-size with one we build ourselves
      ln_sf (Formula["macos-term-size"].opt_bin/"term-size").relative_path_from(macos_dir), macos_dir
    end
  end

  test do
    (testpath/"test.exp").write <<~EOS
      spawn #{bin}/firebase login:ci --no-localhost
      expect "Paste"
    EOS
    assert_match "authorization code", shell_output("expect -f test.exp")
  end
end
