require "language/node"

class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-28.4.1.tgz"
  sha256 "85e311c3a1d05b94abf607a16fc7a6108d33c197b56fdd02462b53f867a81d9d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "263cd1be3fd13fdd3a26904d26c54816945e687953bdeb26077a83afe5f76f61"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "263cd1be3fd13fdd3a26904d26c54816945e687953bdeb26077a83afe5f76f61"
    sha256 cellar: :any_skip_relocation, monterey:       "c841bc36a863e58abe58a7581af5f121b197a96fbddb950019ad3ba9843a9a22"
    sha256 cellar: :any_skip_relocation, big_sur:        "e985fe8d7d627bd52921bd51ff67fae546ed61f819cced50131a59b499d91c1a"
    sha256 cellar: :any_skip_relocation, catalina:       "e985fe8d7d627bd52921bd51ff67fae546ed61f819cced50131a59b499d91c1a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0d6a050a4a85add0ec1dd6d8807ca21fec95acf1bc9252282f45de7e084e85e1"
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
