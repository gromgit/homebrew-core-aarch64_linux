require "language/node"

class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-10.7.0.tgz"
  sha256 "a07cd44f845f95e9401fc6a58e0484bdb4e16ab0dbd89219d8c4a5c6e0162019"
  license "MIT"
  head "https://github.com/firebase/firebase-tools.git", branch: "master"

  bottle do
    sha256                               arm64_monterey: "fc97923311b14a6f3e1bb518184dfc9b14a73801880581cad1c3f4f7ed7ef2fc"
    sha256                               arm64_big_sur:  "cce070f4b142b22b93604a6558863d5c7fd84b99aace05cff86b12c8d8dfa724"
    sha256 cellar: :any_skip_relocation, monterey:       "b0879596b9b464054e3f2d01df161ae7b8bb33eb4afbeb3f0a3ccbec85c0363d"
    sha256 cellar: :any_skip_relocation, big_sur:        "b0879596b9b464054e3f2d01df161ae7b8bb33eb4afbeb3f0a3ccbec85c0363d"
    sha256 cellar: :any_skip_relocation, catalina:       "b0879596b9b464054e3f2d01df161ae7b8bb33eb4afbeb3f0a3ccbec85c0363d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "febef05116cb934bf904b2955070722aa98e5f7d3203f15374f4c7575f1d506f"
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
