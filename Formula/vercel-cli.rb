require "language/node"

class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-28.4.1.tgz"
  sha256 "85e311c3a1d05b94abf607a16fc7a6108d33c197b56fdd02462b53f867a81d9d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "06465b802305f0b5f486a20bae519a75ea503e5809a991b2a96209db667f13a7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "06465b802305f0b5f486a20bae519a75ea503e5809a991b2a96209db667f13a7"
    sha256 cellar: :any_skip_relocation, monterey:       "88b0cbe0a14a88e5c9b18dc6e8f331fe45fcba992cf16fa976cc691c6e02b131"
    sha256 cellar: :any_skip_relocation, big_sur:        "0f0ec3697abfa9e04697919b79a9c0bdbdc556cb8b4f7c058b33d1ec4ba7e2ed"
    sha256 cellar: :any_skip_relocation, catalina:       "0f0ec3697abfa9e04697919b79a9c0bdbdc556cb8b4f7c058b33d1ec4ba7e2ed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "081c9737ec19a27601999b53d05d547686b9bc4972918982688ecb42686e4f3c"
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
