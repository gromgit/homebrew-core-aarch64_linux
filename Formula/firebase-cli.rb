require "language/node"

class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-10.0.1.tgz"
  sha256 "cfa57ac33a7b81e923ab3712fa5e0c10cc4c514294a4d1aa77442bfca5525df3"
  license "MIT"
  head "https://github.com/firebase/firebase-tools.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a85aee54e920b15e4a26425dc846120ac96e491c00951dccdd2cd2c7997eb311"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a85aee54e920b15e4a26425dc846120ac96e491c00951dccdd2cd2c7997eb311"
    sha256 cellar: :any_skip_relocation, monterey:       "050174230961f23456eb3c09207243ada3d0dd596c2df66342ca78ca41d78d28"
    sha256 cellar: :any_skip_relocation, big_sur:        "050174230961f23456eb3c09207243ada3d0dd596c2df66342ca78ca41d78d28"
    sha256 cellar: :any_skip_relocation, catalina:       "050174230961f23456eb3c09207243ada3d0dd596c2df66342ca78ca41d78d28"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b778cafe9206af86ed67b927ff0f14f5b53b958f45b919cb96a7c74b3e52e927"
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
