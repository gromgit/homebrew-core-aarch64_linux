require "language/node"

class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-28.1.1.tgz"
  sha256 "acc90f7e72304ad112f4a14bdc32b06faa8da79ffd1b4207afcd89197646d973"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9bbafd9f72df62ec4dbc299f58a4135777c48338c5d6d53cf19a588428f1f786"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9bbafd9f72df62ec4dbc299f58a4135777c48338c5d6d53cf19a588428f1f786"
    sha256 cellar: :any_skip_relocation, monterey:       "25b20a10fb6c22d35c9bb5740ffc7e72130a0bb7cae55355e8691140a809dedc"
    sha256 cellar: :any_skip_relocation, big_sur:        "2bc731195bcea6c84a842f947d200396ecc6cc6f72b484416b8a1e74017ce837"
    sha256 cellar: :any_skip_relocation, catalina:       "2bc731195bcea6c84a842f947d200396ecc6cc6f72b484416b8a1e74017ce837"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dee5c4337fdcca0425c25c9546779a04e74e51a0375877a8f8dd136223741d81"
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
