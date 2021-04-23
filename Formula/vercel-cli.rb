require "language/node"

class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-22.0.1.tgz"
  sha256 "e365b176cdce22da8d3f44c7ca6853b1d8cb5b47930e983fe2d3bb97f807c066"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "08781018d891011a3fa4f8b2f4d51365adad4f64bb02e0e3c6b0dbbfec973ef9"
    sha256 cellar: :any_skip_relocation, big_sur:       "d1fe9532fd624e6e9e13c393e28217e11d8e72f8200ded254604c45b68cade83"
    sha256 cellar: :any_skip_relocation, catalina:      "d1fe9532fd624e6e9e13c393e28217e11d8e72f8200ded254604c45b68cade83"
    sha256 cellar: :any_skip_relocation, mojave:        "d1fe9532fd624e6e9e13c393e28217e11d8e72f8200ded254604c45b68cade83"
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
