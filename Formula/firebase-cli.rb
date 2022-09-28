require "language/node"

class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-11.11.0.tgz"
  sha256 "fdb393cabfceccbc39899647f5986f46485b4ea15f516c95e4c3b5f3577b4dcf"
  license "MIT"
  head "https://github.com/firebase/firebase-tools.git", branch: "master"

  bottle do
    sha256                               arm64_monterey: "c75c3fb940ea767227dd83aca65b1a4c51ab89ec8ca46882066750250ef3043e"
    sha256                               arm64_big_sur:  "120dbd04c87470afefdadf6d75508ed0ef13c5bbc884dfd3ae033aa69ac88b11"
    sha256 cellar: :any_skip_relocation, monterey:       "925b438c02fa9bc761bfdc5164693792c304575b68747bb5fb89d5e1c59a96bb"
    sha256 cellar: :any_skip_relocation, big_sur:        "925b438c02fa9bc761bfdc5164693792c304575b68747bb5fb89d5e1c59a96bb"
    sha256 cellar: :any_skip_relocation, catalina:       "925b438c02fa9bc761bfdc5164693792c304575b68747bb5fb89d5e1c59a96bb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f1afa31bff01696255a3751d0ccc281a1656c700693a712f9e431fbf2d150315"
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
