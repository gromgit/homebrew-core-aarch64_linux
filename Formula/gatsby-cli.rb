require "language/node"

class GatsbyCli < Formula
  desc "Gatsby command-line interface"
  homepage "https://www.gatsbyjs.org/docs/gatsby-cli/"
  # gatsby-cli should only be updated every 10 releases on multiples of 10
  url "https://registry.npmjs.org/gatsby-cli/-/gatsby-cli-4.22.0.tgz"
  sha256 "51492360f8e94e07b0d572a2f948a0924f8b41a893b001314ba27dc6faba5249"
  license "MIT"

  bottle do
    sha256                               arm64_monterey: "cf13cc5abcb5415f2ee717e32ce4d25918a4c8586422ad4ffe299275186608a6"
    sha256                               arm64_big_sur:  "5e4861bb2a56d07dcdd337e3763c4d44d07cece5e6dd225ab20a9d41dea30789"
    sha256                               monterey:       "1815f6040f312a757866c56ea0ad7d39b343b0f44062b55f90e39aa427e3834f"
    sha256                               big_sur:        "978a78699fccc19c473ca5c135a2539abd7edfc637a997fb5667eccb38aba3d8"
    sha256                               catalina:       "e3dca04a1b091c5c6a572fde030202654433f1f332b9e9ae7dbc2a5ab4e97800"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e3f0f647e04fa58d9022c9079de78779a1d2bab647c258d7587bccaa01ed3b0d"
  end

  depends_on "node"

  on_macos do
    depends_on "macos-term-size"
  end

  on_linux do
    depends_on "xsel"
  end

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir[libexec/"bin/*"]

    # Remove incompatible pre-built binaries
    node_modules = libexec/"lib/node_modules/#{name}/node_modules"
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    if OS.linux?
      %w[@lmdb/lmdb @msgpackr-extract/msgpackr-extract].each do |mod|
        node_modules.glob("#{mod}-linux-#{arch}/*.musl.node")
                    .map(&:unlink)
                    .empty? && raise("Unable to find #{mod} musl library to delete.")
      end
    end

    term_size_vendor_dir = node_modules/"term-size/vendor"
    term_size_vendor_dir.rmtree # remove pre-built binaries
    if OS.mac?
      macos_dir = term_size_vendor_dir/"macos"
      macos_dir.mkpath
      # Replace the vendored pre-built term-size with one we build ourselves
      ln_sf (Formula["macos-term-size"].opt_bin/"term-size").relative_path_from(macos_dir), macos_dir
    end

    clipboardy_fallbacks_dir = node_modules/"clipboardy/fallbacks"
    clipboardy_fallbacks_dir.rmtree # remove pre-built binaries
    if OS.linux?
      linux_dir = clipboardy_fallbacks_dir/"linux"
      linux_dir.mkpath
      # Replace the vendored pre-built xsel with one we build ourselves
      ln_sf (Formula["xsel"].opt_bin/"xsel").relative_path_from(linux_dir), linux_dir
    end
  end

  test do
    system bin/"gatsby", "new", "hello-world", "https://github.com/gatsbyjs/gatsby-starter-hello-world"
    assert_predicate testpath/"hello-world/package.json", :exist?, "package.json was not cloned"
  end
end
