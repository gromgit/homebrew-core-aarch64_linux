require "language/node"

class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-11.12.0.tgz"
  sha256 "fbdfd10d72a0500fd3fd4a3eda6afec8128d5efe68ce54cd855155d9a703b70f"
  license "MIT"
  head "https://github.com/firebase/firebase-tools.git", branch: "master"

  bottle do
    sha256                               arm64_monterey: "6cc743130d9feb1a12def1a4db445c0dc206df6d97b8a6ae8e53a8a94bc54c94"
    sha256                               arm64_big_sur:  "f0869501d99d28683e5da72432332b421fa693bb0f91dea6cec7564777b74882"
    sha256 cellar: :any_skip_relocation, monterey:       "a87193846b0e137ca5773fc095bad05eb1f7743c058dc226da2148278c0d909a"
    sha256 cellar: :any_skip_relocation, big_sur:        "a87193846b0e137ca5773fc095bad05eb1f7743c058dc226da2148278c0d909a"
    sha256 cellar: :any_skip_relocation, catalina:       "a87193846b0e137ca5773fc095bad05eb1f7743c058dc226da2148278c0d909a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "166b0c6d888eeccba96b01ed1ff2509855c7e53feb5714b09ae3bf90718727b9"
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
