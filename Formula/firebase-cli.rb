require "language/node"

class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-10.9.0.tgz"
  sha256 "3a851e24c789a3a91f5076bb3ef0b4eebd7fb09ecf0d15077827db979b4a7498"
  license "MIT"
  head "https://github.com/firebase/firebase-tools.git", branch: "master"

  bottle do
    sha256                               arm64_monterey: "f8fc05d9fb70082473b5d644c6117705031907731ddc21c3c930ab28ab80fa48"
    sha256                               arm64_big_sur:  "c62be66c3d93c865727feefd321e49badccab6ac19cecfb5f470724f977d15a9"
    sha256                               monterey:       "6366752f7bae04da02e0c260c9df6ea2c2d986e2a0b005283103db21fcec75f2"
    sha256                               big_sur:        "abeb4fb0b493c05db3ffc821d01f9608a76fdbb8b6aef1c2d828b9b68754402f"
    sha256                               catalina:       "0276193ff28c2882ec64dcb71612d76775afe8a70295bcf9ee5e698ae64f20bd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3a50691274101f980dc819469e6d9a445ad568792b207b4a81f7b75d300f076a"
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
