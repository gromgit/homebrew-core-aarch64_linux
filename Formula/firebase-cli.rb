require "language/node"

class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-11.13.0.tgz"
  sha256 "6ea6fbb2c82ef80dc27109de4121fe43105f41925b003db0a5691603dd17cb91"
  license "MIT"
  head "https://github.com/firebase/firebase-tools.git", branch: "master"

  bottle do
    sha256                               arm64_monterey: "5eb548cefa42ce5f68e82cbfc116fd9fb68b813173f21bb02602bdc8a0be24c2"
    sha256                               arm64_big_sur:  "dbfe0cac404ff5e8bf382dd58a2b45917dd30728538a5824e30b76f3692995d5"
    sha256 cellar: :any_skip_relocation, monterey:       "cf763971f484888272120fd79dad991e26a0dcd915e5be4b2eed67aefcc96891"
    sha256 cellar: :any_skip_relocation, big_sur:        "cf763971f484888272120fd79dad991e26a0dcd915e5be4b2eed67aefcc96891"
    sha256 cellar: :any_skip_relocation, catalina:       "cf763971f484888272120fd79dad991e26a0dcd915e5be4b2eed67aefcc96891"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7c0e6ac6ab554d7bcbd3e88fc9a1b33491193b2d42c8de5e435a4f3045e6c409"
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
