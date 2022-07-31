require "language/node"

class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-27.3.3.tgz"
  sha256 "dfffa6cf8526738cf4f34137f9ef4a3e76819141730541a353b4c8ab6445db39"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "194b0d8f67aa71f4ec4aa8448ea6b41715754b83ba813b2f4ecf07af9a58ba83"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "194b0d8f67aa71f4ec4aa8448ea6b41715754b83ba813b2f4ecf07af9a58ba83"
    sha256 cellar: :any_skip_relocation, monterey:       "2b598b22ec8bce25c2f0049c66799f61a4346666bb29b20eae0c71736b19782a"
    sha256 cellar: :any_skip_relocation, big_sur:        "58bdbaabc7759fa33e35fc5a0a98c42b5c372de4e0a141f95a6751ce94236094"
    sha256 cellar: :any_skip_relocation, catalina:       "58bdbaabc7759fa33e35fc5a0a98c42b5c372de4e0a141f95a6751ce94236094"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6f06197fb39b75333b7a5b289a0428c27eb99bf06c52358a30833c9b058d4c8b"
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
