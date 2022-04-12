require "language/node"

class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-24.1.0.tgz"
  sha256 "ecde01471a5056197aa1575deebd0e831648e99a85faab7feddeb2e86980e9a2"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "99101da120f24a72e0e8eacf8653ee7cfca8c515181fd574c44fb1a8e6a633cd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "99101da120f24a72e0e8eacf8653ee7cfca8c515181fd574c44fb1a8e6a633cd"
    sha256 cellar: :any_skip_relocation, monterey:       "2e181a6ae3b586afb3172ff46a65cc7adab5df81029c24c58a4c48377da2469b"
    sha256 cellar: :any_skip_relocation, big_sur:        "2e181a6ae3b586afb3172ff46a65cc7adab5df81029c24c58a4c48377da2469b"
    sha256 cellar: :any_skip_relocation, catalina:       "2e181a6ae3b586afb3172ff46a65cc7adab5df81029c24c58a4c48377da2469b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e5b2c4809cb9a632c414cca18fb1f10e22cbcb17f9efe13ae06683c4f957d284"
  end

  depends_on "node"

  on_macos do
    depends_on "macos-term-size"
  end

  def install
    rm Dir["dist/{*.exe,xsel}"]
    inreplace "dist/index.js", "exports.default = getUpdateCommand",
                               "exports.default = async()=>'brew upgrade vercel-cli'"
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]

    term_size_vendor_dir = libexec/"lib/node_modules/vercel/node_modules/term-size/vendor"
    term_size_vendor_dir.rmtree # remove pre-built binaries

    dist_dir = libexec/"lib/node_modules/vercel/dist"
    rm_rf dist_dir/"term-size"

    if OS.mac?
      macos_dir = term_size_vendor_dir/"macos"
      macos_dir.mkpath
      # Replace the vendored pre-built term-size with one we build ourselves
      ln_sf (Formula["macos-term-size"].opt_bin/"term-size").relative_path_from(macos_dir), macos_dir
      ln_sf (Formula["macos-term-size"].opt_bin/"term-size").relative_path_from(dist_dir), dist_dir
    end
  end

  test do
    system "#{bin}/vercel", "init", "jekyll"
    assert_predicate testpath/"jekyll/_config.yml", :exist?, "_config.yml must exist"
    assert_predicate testpath/"jekyll/README.md", :exist?, "README.md must exist"
  end
end
