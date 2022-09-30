require "language/node"

class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-11.12.0.tgz"
  sha256 "fbdfd10d72a0500fd3fd4a3eda6afec8128d5efe68ce54cd855155d9a703b70f"
  license "MIT"
  head "https://github.com/firebase/firebase-tools.git", branch: "master"

  bottle do
    sha256                               arm64_monterey: "c1eb22ed6036f5417bd517fd290d01251eacd6566490f0168d775fd27b24bab3"
    sha256                               arm64_big_sur:  "0e2d1fd35b23c32ce08adf17e5f9da3b4915062efe4e55630d411749286e0c90"
    sha256 cellar: :any_skip_relocation, monterey:       "d7041c6afbe075441efe2d9f42f560b3a582b00f954bffe979364d9927032962"
    sha256 cellar: :any_skip_relocation, big_sur:        "d7041c6afbe075441efe2d9f42f560b3a582b00f954bffe979364d9927032962"
    sha256 cellar: :any_skip_relocation, catalina:       "d7041c6afbe075441efe2d9f42f560b3a582b00f954bffe979364d9927032962"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e94786eef14cec768b56c089154dbb733f2bb94b219617d6b6c08d3599210b2b"
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
