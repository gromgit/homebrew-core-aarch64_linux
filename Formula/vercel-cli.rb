require "language/node"

class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-28.1.3.tgz"
  sha256 "1b90980c8d4ae155d4c23ce99d00c21647f82fc96ad7bda906b981805e64619b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4f1a2c5b62380cd361a30ceb428aa391b12d8c006779e4a1ae4474ccb96583df"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4f1a2c5b62380cd361a30ceb428aa391b12d8c006779e4a1ae4474ccb96583df"
    sha256 cellar: :any_skip_relocation, monterey:       "adadb66ea5b9b8410fce0fdfcd5963ce029e7e57e876629edbb97bdcab07fd3d"
    sha256 cellar: :any_skip_relocation, big_sur:        "20e0967444a18a24706d23394548714728ddb3604679dd2e6d3c7779464e53b9"
    sha256 cellar: :any_skip_relocation, catalina:       "20e0967444a18a24706d23394548714728ddb3604679dd2e6d3c7779464e53b9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9f21c3513c9bf0ce010870b7d92d95421f9518ea0901b406eddbb793814c8a25"
  end

  depends_on "node"

  on_macos do
    depends_on "macos-term-size"
  end

  def install
    rm Dir["dist/{*.exe,xsel}"]
    inreplace "dist/index.js", "= getUpdateCommand",
                               "= async()=>'brew upgrade vercel-cli'"
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]

    dist_dir = libexec/"lib/node_modules/vercel/dist"
    rm_rf dist_dir/"term-size"

    if OS.mac?
      # Replace the vendored pre-built term-size with one we build ourselves
      ln_sf (Formula["macos-term-size"].opt_bin/"term-size").relative_path_from(dist_dir), dist_dir
    end
  end

  test do
    system "#{bin}/vercel", "init", "jekyll"
    assert_predicate testpath/"jekyll/_config.yml", :exist?, "_config.yml must exist"
    assert_predicate testpath/"jekyll/README.md", :exist?, "README.md must exist"
  end
end
