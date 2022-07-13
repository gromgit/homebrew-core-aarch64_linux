require "language/node"

class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-11.2.2.tgz"
  sha256 "cdccfce1fe39abe2c7f3323da8dd2011d4c259820a8d69cbddfee87b0953febd"
  license "MIT"
  head "https://github.com/firebase/firebase-tools.git", branch: "master"

  bottle do
    sha256                               arm64_monterey: "2f8d3993c63dcb1c3422db222ced8cd4a5a321e8b3f7d7d026598d652ce1978d"
    sha256                               arm64_big_sur:  "afada1476deb451450b384ae9eb127a4f7042738a76312cc01d3aacf2891dc4b"
    sha256 cellar: :any_skip_relocation, monterey:       "0ad77e2525d2b5ed03d86b461ec9e1a94cdaaeb780a951df72c09fd675de7de2"
    sha256 cellar: :any_skip_relocation, big_sur:        "0ad77e2525d2b5ed03d86b461ec9e1a94cdaaeb780a951df72c09fd675de7de2"
    sha256 cellar: :any_skip_relocation, catalina:       "0ad77e2525d2b5ed03d86b461ec9e1a94cdaaeb780a951df72c09fd675de7de2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d3c29a794e58f6728de21f7d7ab6d349d83f7dc0a6ca99d76500b1c9bc447975"
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
