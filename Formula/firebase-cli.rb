require "language/node"

class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-10.8.0.tgz"
  sha256 "1591537a361b3f70767d9f25d2bef2f42163c6f8914a8a6eed547d74859aee92"
  license "MIT"
  head "https://github.com/firebase/firebase-tools.git", branch: "master"

  bottle do
    sha256                               arm64_monterey: "7558a7aec0a0b00cb3a425dd108f39ebb18bcab73cb7f01ffc725fe8fec7cc01"
    sha256                               arm64_big_sur:  "cc422a808ee3505bda60c047f6a32305c066ef7e97e8838ffd5b1692f8f8ece3"
    sha256                               monterey:       "e690183d3ffe1e15fdf483ed3fd81bdfd156449031a2eb9c06d6c9505fd4b864"
    sha256                               big_sur:        "eeb0f0118f1367d9a9baae6b9cbe5ecab2121026da1286d98293be498d6b39d5"
    sha256                               catalina:       "9367201dcb4d787ad4f1218b0ae5e3b991921aa1bdbe7fefe43f3d0a9fbd8c17"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b0a3c310f7a3e406f77501037cdae3eda306032639b0b628fa1e23cc12b6fc08"
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
