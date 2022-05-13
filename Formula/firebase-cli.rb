require "language/node"

class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-10.9.2.tgz"
  sha256 "544f3d20936f0bcf7ab6238fa0ad9023860b6e87c3106d88de78121be0a9552b"
  license "MIT"
  head "https://github.com/firebase/firebase-tools.git", branch: "master"

  bottle do
    sha256                               arm64_monterey: "4d2d7af9c3286f7e708a8e6c6736dc4ed8505f4600aa6510705820a8d3c85966"
    sha256                               arm64_big_sur:  "06cc19168d6c13ecfac19311516a6202f547e1f9ec4ffe7e5b0b08b77e4d19b5"
    sha256                               monterey:       "622ac25dbc9617d5b570ae5f5506f51f3c49dc01891a7b6d55ecf73545103208"
    sha256                               big_sur:        "d8a219c51f1856ab60bef68e9810a803dcd6bac2987d63e5fb9f127699227cd4"
    sha256                               catalina:       "d9f9c0aea81d6cdd5c97dd9359a0e7e6c305f476bb0c5f54a62f1bb4a60291c1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "26254c1059bd7ab995aaca6ebd6888fe7a1308790cc9201f13d0a34b99663193"
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
