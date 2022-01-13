require "language/node"

class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-10.1.0.tgz"
  sha256 "490f834b44f46d2e65726301b9763a88e45c939a94613b3568afc6e6c4bffc03"
  license "MIT"
  head "https://github.com/firebase/firebase-tools.git", branch: "master"

  bottle do
    sha256                               arm64_monterey: "cd2dbf470ee1bbcb0dcd712aabd28d4497d76c77a655ddfed3f609e3caceeef8"
    sha256                               arm64_big_sur:  "9a68475c2e9c427387271c26263cd5202e041f10055894714ad84000324b43c0"
    sha256 cellar: :any_skip_relocation, monterey:       "65d328e1fe5095b2f5e08641ebcd73dbbc04db6c2e691d612138fbb7ffec45f9"
    sha256 cellar: :any_skip_relocation, big_sur:        "65d328e1fe5095b2f5e08641ebcd73dbbc04db6c2e691d612138fbb7ffec45f9"
    sha256 cellar: :any_skip_relocation, catalina:       "65d328e1fe5095b2f5e08641ebcd73dbbc04db6c2e691d612138fbb7ffec45f9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "68b9b510da8e2d4ee9305ca43d1edff5ec07ddc0d75340449f37808cad1945fe"
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
