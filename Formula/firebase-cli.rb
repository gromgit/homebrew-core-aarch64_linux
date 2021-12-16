require "language/node"

class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-10.0.0.tgz"
  sha256 "6425d4a1df9b90424144aa477cd47f1bd59f5ac810c82b1d4e1156aa1636b894"
  license "MIT"
  head "https://github.com/firebase/firebase-tools.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e5eba4e8cec2d00486767145f73c4a23d729e7263061bd5f33e451741656dc8e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e5eba4e8cec2d00486767145f73c4a23d729e7263061bd5f33e451741656dc8e"
    sha256 cellar: :any_skip_relocation, monterey:       "3ade6a4be4b6af4ef66cfe7b06ffbdb0e2a199870fd7c221b50471241c73aa1d"
    sha256 cellar: :any_skip_relocation, big_sur:        "3ade6a4be4b6af4ef66cfe7b06ffbdb0e2a199870fd7c221b50471241c73aa1d"
    sha256 cellar: :any_skip_relocation, catalina:       "3ade6a4be4b6af4ef66cfe7b06ffbdb0e2a199870fd7c221b50471241c73aa1d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "180c5cd76b348a85e778f19958f1cf40e3ce1500a1989e2b7e5bb9674aef06ec"
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
