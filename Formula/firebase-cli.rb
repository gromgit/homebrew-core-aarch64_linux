require "language/node"

class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-11.2.1.tgz"
  sha256 "0eb569bb5417eba67168ca21f928a54f29f0b575360b7f9d31215f03ef9a2666"
  license "MIT"
  head "https://github.com/firebase/firebase-tools.git", branch: "master"

  bottle do
    sha256                               arm64_monterey: "dec6d3fe8a4506b41a2606d85c66252bec5dab481a831263df0e2fbbfeae7f0e"
    sha256                               arm64_big_sur:  "3bd9e8313a06c219de5a752f82ccb1c3cba08791d111d7031615fcaa9c187332"
    sha256 cellar: :any_skip_relocation, monterey:       "cfeedfedd64c1fd36a2cb487bc7b28f5dce24ceaa072c3ccb1487130691a1b66"
    sha256 cellar: :any_skip_relocation, big_sur:        "cfeedfedd64c1fd36a2cb487bc7b28f5dce24ceaa072c3ccb1487130691a1b66"
    sha256 cellar: :any_skip_relocation, catalina:       "cfeedfedd64c1fd36a2cb487bc7b28f5dce24ceaa072c3ccb1487130691a1b66"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "41467cf5e4af8a85a11f7a5108e555e75d9020ee8228b8469e1ea37a8289680d"
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
