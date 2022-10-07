require "language/node"

class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-28.4.8.tgz"
  sha256 "97094a250f62bd79e4f9ba60751b8b00e20536268d40ac9a8be2c3c5e8d8faef"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d9caac8c3f339769fbaa20362b78d5e2c335ac3d74f3117dd5019c529f4918ed"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d9caac8c3f339769fbaa20362b78d5e2c335ac3d74f3117dd5019c529f4918ed"
    sha256 cellar: :any_skip_relocation, monterey:       "27e7fca3c5dd26ff20d5c69c82fe07a8bcb2f7fd84e6d0265c90ca0a97234e41"
    sha256 cellar: :any_skip_relocation, big_sur:        "3132d51506f886440a87b25a8631985f3a16f82e60d141c6671694335da1e887"
    sha256 cellar: :any_skip_relocation, catalina:       "3132d51506f886440a87b25a8631985f3a16f82e60d141c6671694335da1e887"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4fb4ed22b384ef4be96c0ddfbf2cb3a04736835a87d746c77114f7ebe43b4571"
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
