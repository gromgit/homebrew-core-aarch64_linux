require "language/node"

class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-9.19.0.tgz"
  sha256 "b89e5bfae1ae9cd39c880a9713caa73b67fecbbffdba123dd1dd18cd70b2ef9b"
  license "MIT"
  head "https://github.com/firebase/firebase-tools.git"

  bottle do
    sha256                               arm64_big_sur: "55bf4444374200b5d9328e7c42e1ea821e3b857a01560a2e7ebbf414a92c4cea"
    sha256 cellar: :any_skip_relocation, big_sur:       "d403d4fd6e5af5983947fb8474569a0e35fb75aa0ff9144437b77136b468b8ab"
    sha256 cellar: :any_skip_relocation, catalina:      "d403d4fd6e5af5983947fb8474569a0e35fb75aa0ff9144437b77136b468b8ab"
    sha256 cellar: :any_skip_relocation, mojave:        "d403d4fd6e5af5983947fb8474569a0e35fb75aa0ff9144437b77136b468b8ab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d92a711d96690d9b81c5ea4d761d19120877ade500aae9f3de0744a72f33272b"
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
