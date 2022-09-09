require "language/node"

class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-11.8.1.tgz"
  sha256 "c09d0c207d6aef9f11f7c096e7d8bad0cc8dff1b4c7ed87205606884a15745d1"
  license "MIT"
  head "https://github.com/firebase/firebase-tools.git", branch: "master"

  bottle do
    sha256                               arm64_monterey: "54a98b3b73e7ab6338bdd7354a8b1f8566831e7e777166a0890a8b902a83dc54"
    sha256                               arm64_big_sur:  "88a66074e1ca71314aa1e707e98ffea2e02cfc2134cc37112ed85f8306c92fd2"
    sha256 cellar: :any_skip_relocation, monterey:       "f36dcf745f0f074269cad15406fa0e077824ef54d63a2d739ed3ba8e69e7199f"
    sha256 cellar: :any_skip_relocation, big_sur:        "f36dcf745f0f074269cad15406fa0e077824ef54d63a2d739ed3ba8e69e7199f"
    sha256 cellar: :any_skip_relocation, catalina:       "f36dcf745f0f074269cad15406fa0e077824ef54d63a2d739ed3ba8e69e7199f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9735ee7a4340e09ba5cbe131a84b0f516cffc1b1832a4a35b74a7acb7870ef17"
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
