require "language/node"

class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-28.4.4.tgz"
  sha256 "b8254068098c6bab1f0e46be8203233e78daed7e7a80d430e05337ff3ce0a10d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "776c60629f3993f360764f499f57a3fefdb57ee067e253616d679b96143ce8ea"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "776c60629f3993f360764f499f57a3fefdb57ee067e253616d679b96143ce8ea"
    sha256 cellar: :any_skip_relocation, monterey:       "5ca05592630ac1b5210cd2b6ae8676ccff6f2cf26534afe2fb09e419e72cc67f"
    sha256 cellar: :any_skip_relocation, big_sur:        "734c8250fa13fa740e7a1711f0ed0d3abf0c7f65e3a42b41f174a77ff7dc4bf4"
    sha256 cellar: :any_skip_relocation, catalina:       "734c8250fa13fa740e7a1711f0ed0d3abf0c7f65e3a42b41f174a77ff7dc4bf4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4581ecf3de757db92a9151897d124441b6f677f1ee69d2796693a5fb6ee9b553"
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
