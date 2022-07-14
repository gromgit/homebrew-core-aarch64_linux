require "language/node"

class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-27.1.2.tgz"
  sha256 "8686aed4eb67a46717a6d3fb35042477eaeeaf431b6e3b8a8facf0a626403d13"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f3e454a63bd6a1ca4b181cecf781e74a735c4ce5e59388f9fdaf4ae79008a242"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f3e454a63bd6a1ca4b181cecf781e74a735c4ce5e59388f9fdaf4ae79008a242"
    sha256 cellar: :any_skip_relocation, monterey:       "2a01adf5438626bae2154f37bad1a8d8f11c02c04f2783cfa62a508b899dcdca"
    sha256 cellar: :any_skip_relocation, big_sur:        "bc2b2da336d6a05c9e58ba6394389885db762e55e70036412f0c139945731bf4"
    sha256 cellar: :any_skip_relocation, catalina:       "bc2b2da336d6a05c9e58ba6394389885db762e55e70036412f0c139945731bf4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e72e1f99fce625d4c13a909e8e31e0f9180a4081714d464a13729cb20c25ebc2"
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
