require "language/node"

class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-27.3.7.tgz"
  sha256 "4eb0c783b6a943d24d802a6e10220bb6df72b2da11e5a965229595168684e19a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e8667676e2004860570530dd041c288970937c3d4f6997bceccc5faf344c6fae"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e8667676e2004860570530dd041c288970937c3d4f6997bceccc5faf344c6fae"
    sha256 cellar: :any_skip_relocation, monterey:       "125afaf87e7703db47712b37cba1f4bd0f8219928ba73a2d2c54f90031c4143a"
    sha256 cellar: :any_skip_relocation, big_sur:        "6003fabbda78fb0a63b7c3b89f2ed01c445bb6edf63c87d8fc95d0ec96d602f5"
    sha256 cellar: :any_skip_relocation, catalina:       "6003fabbda78fb0a63b7c3b89f2ed01c445bb6edf63c87d8fc95d0ec96d602f5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "70a3b5a8f5ee3065f3e481a1b48860832e564e0dccef0bcbe08b47bafe003e30"
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
