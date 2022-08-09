require "language/node"

class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-11.5.0.tgz"
  sha256 "2d59cc1e2e92b335566a2f3fce0bf956f5027cc5e0fde1bba11767b3379c51cb"
  license "MIT"
  head "https://github.com/firebase/firebase-tools.git", branch: "master"

  bottle do
    sha256                               arm64_monterey: "fc654dac079a82e229a185cda0c88668f2e750a9461d360f8eaac4fe26eaf5bb"
    sha256                               arm64_big_sur:  "e8914bc41d6b62158296ac6a79aba3afdf40bdc24904f6c2f2f2eae110434e41"
    sha256 cellar: :any_skip_relocation, monterey:       "b02163d6bc6b77842873a3996838a6d0be4539849a8015cd8428c160f6a0738b"
    sha256 cellar: :any_skip_relocation, big_sur:        "b02163d6bc6b77842873a3996838a6d0be4539849a8015cd8428c160f6a0738b"
    sha256 cellar: :any_skip_relocation, catalina:       "b02163d6bc6b77842873a3996838a6d0be4539849a8015cd8428c160f6a0738b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "37a6cdb9b2d48fb785a13f8f73bcc05859593576db20ea1a699250973a736048"
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
