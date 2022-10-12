require "language/node"

class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-28.4.10.tgz"
  sha256 "6247660372113326b4dd0515afd1e9d46545a9c900eabb0cffc0ba4dce78067c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "820013dfce63c16f58c8131b19ee18d7677cf2a2d2c31891002e40a1ef4fbc54"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "820013dfce63c16f58c8131b19ee18d7677cf2a2d2c31891002e40a1ef4fbc54"
    sha256 cellar: :any_skip_relocation, monterey:       "067c319741fc7cd72b2d75bad21e30e31111cc0b9ac2b022fc47daf2d661c63d"
    sha256 cellar: :any_skip_relocation, big_sur:        "939f0b9144a44754d169744ce406cf1d0398adfd79d91933b751c802955a2c36"
    sha256 cellar: :any_skip_relocation, catalina:       "939f0b9144a44754d169744ce406cf1d0398adfd79d91933b751c802955a2c36"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d57794a238552a9af0b02b061aff70503e9a2c9d72643eb87ee4b2a98c2f87c3"
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
