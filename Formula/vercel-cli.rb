require "language/node"

class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-21.3.3.tgz"
  sha256 "e2b0d36af7ca06839075a2a8eda6b15087ae9fa9a76c073bfeaeebe4e1e0c71f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "ce9eb32fc34c73b740aa219bc832d93c4ddc7373a001084570ffc8aca4e89196"
    sha256 cellar: :any_skip_relocation, big_sur:       "87d57893b40f67fa7fd7415d932d301630152f5e3e317490712d2e500a31eed6"
    sha256 cellar: :any_skip_relocation, catalina:      "2b7c22143040660cc0044714755f80b4a5860cb6daefd9a567bd680f1f51598f"
    sha256 cellar: :any_skip_relocation, mojave:        "ffbe030b1f2f0a43bca1ced616ee135f67d868438df46a601fcb2132c7894fd6"
  end

  depends_on "node"

  def install
    rm Dir["dist/{*.exe,xsel}"]
    inreplace "dist/index.js", "exports.default = getUpdateCommand",
                               "exports.default = async()=>'brew upgrade vercel-cli'"
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system "#{bin}/vercel", "init", "jekyll"
    assert_predicate testpath/"jekyll/_config.yml", :exist?, "_config.yml must exist"
    assert_predicate testpath/"jekyll/README.md", :exist?, "README.md must exist"
  end
end
