require "language/node"

class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-11.9.0.tgz"
  sha256 "3d44dffee4acc766242ca4ace1834236d338487b6a7303b9ce0fcf2e6e07edc9"
  license "MIT"
  head "https://github.com/firebase/firebase-tools.git", branch: "master"

  bottle do
    sha256                               arm64_monterey: "1521d51df4cf4fc33a1713ad0d6fac5e11034ba641a4f69a5ce9bb649fbf6cb6"
    sha256                               arm64_big_sur:  "f88a6cd2bc4d70a73938042c08faea40d4c0f0a85cae8d75713ffb31050ba150"
    sha256 cellar: :any_skip_relocation, monterey:       "830c4b1bde030eaf1799f621c3e0d8888c9dd887a27a40e2ceb03befba6b0cc5"
    sha256 cellar: :any_skip_relocation, big_sur:        "830c4b1bde030eaf1799f621c3e0d8888c9dd887a27a40e2ceb03befba6b0cc5"
    sha256 cellar: :any_skip_relocation, catalina:       "830c4b1bde030eaf1799f621c3e0d8888c9dd887a27a40e2ceb03befba6b0cc5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a371cc34f641c01e98cb76eb9935e835bdea20fc7879c79e0281262aa8171ad4"
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
