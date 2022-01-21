require "language/node"

class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-10.1.2.tgz"
  sha256 "d0ecbf310f79d8e1ca0ccc27c2f39ef6fcd3d588399b7982b0d6429bd4956328"
  license "MIT"
  head "https://github.com/firebase/firebase-tools.git", branch: "master"

  bottle do
    sha256                               arm64_monterey: "b5e2003745f0c1deb42b58c5a1fa18e32a9f6a10a65096f0a238adb038a3323c"
    sha256                               arm64_big_sur:  "f46cd2b8316321442de031146cd77fefda9e46c1c2ac2b4d86f5aed255058417"
    sha256 cellar: :any_skip_relocation, monterey:       "2440954b6997f1bb769ec242bb351ce622fa7bda002a76df5adf6ad1b69150b5"
    sha256 cellar: :any_skip_relocation, big_sur:        "2440954b6997f1bb769ec242bb351ce622fa7bda002a76df5adf6ad1b69150b5"
    sha256 cellar: :any_skip_relocation, catalina:       "2440954b6997f1bb769ec242bb351ce622fa7bda002a76df5adf6ad1b69150b5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "828495fad670c71dbbadd564d57e552a8fcdb8c13aed8c0ca938584f1f38b5e6"
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
