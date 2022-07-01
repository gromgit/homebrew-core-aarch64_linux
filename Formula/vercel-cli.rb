require "language/node"

class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-25.2.3.tgz"
  sha256 "2c397c901428d4d61621dd720a20669a676954ce3888fb420519fdbf250ec697"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0a7662ae986bffc2507e7adde820c76d512db9aaaa703ac430f57b5cca545366"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0a7662ae986bffc2507e7adde820c76d512db9aaaa703ac430f57b5cca545366"
    sha256 cellar: :any_skip_relocation, monterey:       "7100e1e6c30d9c6356891c489b54c4d09a1b35a4849f3ae779f623b51c2a1878"
    sha256 cellar: :any_skip_relocation, big_sur:        "17d8f33d64b3a7404f38187f3bc31d0881b16dab3ff4a1d6ce42e8f8dd9dd4ca"
    sha256 cellar: :any_skip_relocation, catalina:       "17d8f33d64b3a7404f38187f3bc31d0881b16dab3ff4a1d6ce42e8f8dd9dd4ca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ca3827c1ac8948e87dd0124fd68d20bba5de80f6ea222a0a135663e9487b423e"
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
