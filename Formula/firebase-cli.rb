require "language/node"

class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-9.23.2.tgz"
  sha256 "287bd1477c908411e53937788c978faf99849d42ff90f34a066089a94a06eb3c"
  license "MIT"
  head "https://github.com/firebase/firebase-tools.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "33a76fe91fe6eba105135bfd4bcead856af418557315941d632e13dddc0db718"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "33a76fe91fe6eba105135bfd4bcead856af418557315941d632e13dddc0db718"
    sha256 cellar: :any_skip_relocation, monterey:       "d5cf3a4a067982e5b7d27e552a0dc0327ae6cc17d0562b1a074a8646655d9d63"
    sha256 cellar: :any_skip_relocation, big_sur:        "d5cf3a4a067982e5b7d27e552a0dc0327ae6cc17d0562b1a074a8646655d9d63"
    sha256 cellar: :any_skip_relocation, catalina:       "d5cf3a4a067982e5b7d27e552a0dc0327ae6cc17d0562b1a074a8646655d9d63"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d957844fba5924bebad4e2924e226d4a3f2ec199eb41cbffa4861e4f36eec451"
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
