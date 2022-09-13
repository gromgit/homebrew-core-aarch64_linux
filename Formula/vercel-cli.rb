require "language/node"

class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-28.2.5.tgz"
  sha256 "54690bb443f8e460f9ac2aeb1293d22f084004e0df62546e4ee9cb0276dd74c0"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "92cd7c873165f1eaacbae2ba73e83fdd8f324e2a94d6150d774c6efd79b644fd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "92cd7c873165f1eaacbae2ba73e83fdd8f324e2a94d6150d774c6efd79b644fd"
    sha256 cellar: :any_skip_relocation, monterey:       "65fc8fcf3db871e977e35b7b5bbc20c0fcdc5fdf6ac27034b7dd0078c95c6910"
    sha256 cellar: :any_skip_relocation, big_sur:        "6d78b9842e0f05431a1ecd3c8b89c58d4a4d06401976ab38ec92538aaf1f552a"
    sha256 cellar: :any_skip_relocation, catalina:       "6d78b9842e0f05431a1ecd3c8b89c58d4a4d06401976ab38ec92538aaf1f552a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8d51622cb4e6de17b22e5b5ef99ead646794bd5d3b03a6d1b514724ef5c28f20"
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
