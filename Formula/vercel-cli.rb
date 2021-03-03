require "language/node"

class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-21.3.2.tgz"
  sha256 "512430d7857bec64d6b1d9bbfcabd8119cddca93914f6cd58d441824c6ed8453"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "166242c5bb49e6105fbacc6716d69f880ed1df473853018e8ae454ad4d420659"
    sha256 cellar: :any_skip_relocation, big_sur:       "fcf591ef18f9d21100f3ac3ee391daa58658801aea3079c34570c38e2831cd18"
    sha256 cellar: :any_skip_relocation, catalina:      "96a5e011cb21b1b6c582d00bcaac1b9939de8bfd656ea33c06af25653456dee5"
    sha256 cellar: :any_skip_relocation, mojave:        "e7c7fafa34aebf8489157edc8d20eb02d76b239a61b95101262892932ba7a5e8"
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
