require "language/node"

class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-11.4.2.tgz"
  sha256 "fffe2419ae357b7b031df396f84e3e3b6679ef2e46c8672a893b50eb8cd30d1c"
  license "MIT"
  head "https://github.com/firebase/firebase-tools.git", branch: "master"

  bottle do
    sha256                               arm64_monterey: "119d3f870409f5dc4cbdb6c76a223911a47f3e3e5a4ceadc73b66f288c208e50"
    sha256                               arm64_big_sur:  "67524275735a8147e9b365abeee11f3fba8cfac9b51aabdcec2529fbed93bd7d"
    sha256 cellar: :any_skip_relocation, monterey:       "e6555272e1424226cf05205157b7c7994ea9cd3d3261585f1db042693a38f15f"
    sha256 cellar: :any_skip_relocation, big_sur:        "e6555272e1424226cf05205157b7c7994ea9cd3d3261585f1db042693a38f15f"
    sha256 cellar: :any_skip_relocation, catalina:       "e6555272e1424226cf05205157b7c7994ea9cd3d3261585f1db042693a38f15f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6ba7ead0508981a59110a2a78c11c07ce63dbd17d83444b5d4af58c35f6bdbc1"
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
