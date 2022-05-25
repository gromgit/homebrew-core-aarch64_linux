require "language/node"

class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-11.0.1.tgz"
  sha256 "f2c3af58798cf69137863c82ebf6e0bc47646cfece43a3e8a29be678b564eaed"
  license "MIT"
  head "https://github.com/firebase/firebase-tools.git", branch: "master"

  bottle do
    sha256                               arm64_monterey: "4786ed71386bd2dfe39ccc67222be560c1f641a1c0cb72f9619374664760bc2a"
    sha256                               arm64_big_sur:  "015dd91e12d41c76e7d5c41d2a4b31bc5d082cecab634f2aa1f849c79623cf97"
    sha256                               monterey:       "d2c4a027bd3b36ac675e02d9377eebc0c2325c61adfe5450d4e37f26385b6702"
    sha256                               big_sur:        "be5dc8ddad925a3960b346d621120533e84737379ac254c5ee458d97d2dfa725"
    sha256                               catalina:       "0752009c854dbddff0c62cc50d888d98efc6624688f6712a5ac8adf13531331f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bb04a04094a2906ec5912d002297726d0f92871ac56cb60ddc07ef5ca6bb363e"
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
