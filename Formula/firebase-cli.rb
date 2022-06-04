require "language/node"

class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-10.8.0.tgz"
  sha256 "1591537a361b3f70767d9f25d2bef2f42163c6f8914a8a6eed547d74859aee92"
  license "MIT"
  head "https://github.com/firebase/firebase-tools.git", branch: "master"

  bottle do
    sha256                               arm64_monterey: "ea71085f8fc435ed1957be6a99002c30741517d3f23898ea5236a48d2216e7dc"
    sha256                               arm64_big_sur:  "b420795116eefe3e39e075e176439e59939ae880c3d90f93e37a0fe4f13a1e0e"
    sha256                               monterey:       "64901ec38d116901bd6337b41adce85c46fecd1c9069304c1139d6bb460c137e"
    sha256                               big_sur:        "0703878a4795f18bb2ce90753b355b5941a93fb28a32a8d8aaa78ddc5d9bb638"
    sha256                               catalina:       "fc7d010834bfae4680318233c57f632c018dab2f3c1fa1ab0b072a69def0ea60"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a50e499fe55580bc11f3f40e9bd9af51e5decebabf250c027ae185d5ec4770e1"
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
