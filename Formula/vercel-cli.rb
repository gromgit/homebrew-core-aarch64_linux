require "language/node"

class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-28.2.3.tgz"
  sha256 "28886d11097dc0da2e96dc937f5fd8355f7c11b780ba50a3f1a04119e5afe034"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9bdbf45e8ef79c126a74d81de896fcfcb0a41ad2b9cf0082c3909cc9d1f177e3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9bdbf45e8ef79c126a74d81de896fcfcb0a41ad2b9cf0082c3909cc9d1f177e3"
    sha256 cellar: :any_skip_relocation, monterey:       "ed414244a639a386b1dd6bb317caa9f3f90c536aa8d58053f234d44d742f2971"
    sha256 cellar: :any_skip_relocation, big_sur:        "4949963b842b60d33f0939b7a4583aa559d864514998ee61f69fed963f0e5d3b"
    sha256 cellar: :any_skip_relocation, catalina:       "4949963b842b60d33f0939b7a4583aa559d864514998ee61f69fed963f0e5d3b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b936406f2f1202a6757b6227144e162f1c5aa0842aaaee843e0c80590b0e2d59"
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
