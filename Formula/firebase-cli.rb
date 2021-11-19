require "language/node"

class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-9.23.0.tgz"
  sha256 "0486fcf8ab0797e3a18952315352ab760e03a15d4a980bf03c32ab74d2eb9862"
  license "MIT"
  head "https://github.com/firebase/firebase-tools.git"

  bottle do
    sha256                               arm64_monterey: "49701c2d8a531f538dcb90cc0f0ac71246a8ab245a41792aed18ce8fc2f61991"
    sha256                               arm64_big_sur:  "ac226bb813e56009a93bb76efc0c0f62657fc08ae1f7d9f0e38d4d7b4f551917"
    sha256                               monterey:       "89236ef6f8c1e7212bf7f5391b22827b17482634c1aacb36c66957c6d79756fe"
    sha256                               big_sur:        "dc991866658e94b9dc29a5b9d45405c9b0bd63d799f353ede727f3d177100436"
    sha256                               catalina:       "09e75eef9da7a7fa2b266b81344564b776779422b882a715a78497770c1b4d3a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "96af4201a8f20eb29e295391fdfb835942e21beec7837e9e975d8fa6a4c03d0c"
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
