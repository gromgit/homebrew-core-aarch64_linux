require "language/node"

class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-28.4.4.tgz"
  sha256 "b8254068098c6bab1f0e46be8203233e78daed7e7a80d430e05337ff3ce0a10d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c7f410155f29b33388a854a58f2e9a76707ffa13b1688c27f7be3c045a3ded1d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c7f410155f29b33388a854a58f2e9a76707ffa13b1688c27f7be3c045a3ded1d"
    sha256 cellar: :any_skip_relocation, monterey:       "2836349239fb5c329b965975f4fac5de95578bcfa677a270507364eed8d82a83"
    sha256 cellar: :any_skip_relocation, big_sur:        "d21f0f8b151b95832eb5a016a67c51292c222397774abf71248e2124b0e78d2b"
    sha256 cellar: :any_skip_relocation, catalina:       "d21f0f8b151b95832eb5a016a67c51292c222397774abf71248e2124b0e78d2b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a4a09f82679bac85d6e4e7e758d3e8bea7acb63fb8cf31a6fc9dc1c594c66674"
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
