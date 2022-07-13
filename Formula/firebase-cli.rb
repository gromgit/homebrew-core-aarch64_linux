require "language/node"

class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-11.2.2.tgz"
  sha256 "cdccfce1fe39abe2c7f3323da8dd2011d4c259820a8d69cbddfee87b0953febd"
  license "MIT"
  head "https://github.com/firebase/firebase-tools.git", branch: "master"

  bottle do
    sha256                               arm64_monterey: "93448b7838923482c2880424bf01010ccd5d0d24f8aad16052c158efcf356060"
    sha256                               arm64_big_sur:  "e2a1a9e02c84d0871b5205847ceb5d95ada6d69407ac9db69c2455465a4f10bf"
    sha256 cellar: :any_skip_relocation, monterey:       "fcc330d243a2183c41efe73e6c1587726fb429ae448e03f4c04076a1194bb296"
    sha256 cellar: :any_skip_relocation, big_sur:        "fcc330d243a2183c41efe73e6c1587726fb429ae448e03f4c04076a1194bb296"
    sha256 cellar: :any_skip_relocation, catalina:       "fcc330d243a2183c41efe73e6c1587726fb429ae448e03f4c04076a1194bb296"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6b609f5ea2fe21e58ab0b7118e0e9e8ce7ce5a9004c91ddead88f8ba0c927b17"
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
