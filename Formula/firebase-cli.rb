require "language/node"

class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-11.4.0.tgz"
  sha256 "ed65d771780e4f69277485a7be8958c2673014000e6af9405d7cedc82d90b6ab"
  license "MIT"
  head "https://github.com/firebase/firebase-tools.git", branch: "master"

  bottle do
    sha256                               arm64_monterey: "f3fb8166a34e15913924232b7c51652047ad6b3c12281c388d0a9667651bef7f"
    sha256                               arm64_big_sur:  "436714360ec9534bb9d94b8640fae4e265b75e7d130b67f8d30926e438a8de5d"
    sha256 cellar: :any_skip_relocation, monterey:       "4ee7b6226f9f4eceeaf617e013c52f28e0fdf73ffd2d2913a823ab2b9c94e0a3"
    sha256 cellar: :any_skip_relocation, big_sur:        "4ee7b6226f9f4eceeaf617e013c52f28e0fdf73ffd2d2913a823ab2b9c94e0a3"
    sha256 cellar: :any_skip_relocation, catalina:       "4ee7b6226f9f4eceeaf617e013c52f28e0fdf73ffd2d2913a823ab2b9c94e0a3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d2bfe1b54119c512016aad42dc2d7ffb8679be2e0dfd291ab9051f53883c21ce"
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
