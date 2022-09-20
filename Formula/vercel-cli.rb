require "language/node"

class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-28.3.0.tgz"
  sha256 "5d93342b87c7e0586eaaf292d8059dfeeaecd476f4053e851385df5c9bcdf519"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fd7b155752d1fd360b911bd6898c1f665008436cff62df3aaa0a5a1bdb484fdd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fd7b155752d1fd360b911bd6898c1f665008436cff62df3aaa0a5a1bdb484fdd"
    sha256 cellar: :any_skip_relocation, monterey:       "5efcf1e718ac80f9572a26c4cec9f472700225fa38552c2f3ce0a5657fd9932b"
    sha256 cellar: :any_skip_relocation, big_sur:        "5ab9599086055e5f2260592854e1239d167aedd6f28293526a97bf141b6b6ae5"
    sha256 cellar: :any_skip_relocation, catalina:       "5ab9599086055e5f2260592854e1239d167aedd6f28293526a97bf141b6b6ae5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0b1f9b451a22d3189aeb47ee046f17ea4f80b9315a2ed4668495a933f795be2b"
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
