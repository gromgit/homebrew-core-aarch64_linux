require "language/node"

class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-28.2.0.tgz"
  sha256 "4c725e4942d51cb6de6a6825f3709a74eb62aa59683d84e72a97e4d4e70f3f5c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "835053faf056f1053cca68f58fff7a7f134e3ebdbf5743390c9413de4b0d5f17"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "835053faf056f1053cca68f58fff7a7f134e3ebdbf5743390c9413de4b0d5f17"
    sha256 cellar: :any_skip_relocation, monterey:       "fc16094315e34a1c1e21b72a2fa52b303a75b691b1cc5997cff1d030e11b0901"
    sha256 cellar: :any_skip_relocation, big_sur:        "55f6a1194cc3d6ab3f6bc5448b106d408878232a6f6088c5a32c4187dbecbc45"
    sha256 cellar: :any_skip_relocation, catalina:       "55f6a1194cc3d6ab3f6bc5448b106d408878232a6f6088c5a32c4187dbecbc45"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ffeeb63cc4f5dc8d49ab5b1275826fd594f183dc08f0e02ac2ef15943f109a7f"
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
