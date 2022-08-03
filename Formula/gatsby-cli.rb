require "language/node"

class GatsbyCli < Formula
  desc "Gatsby command-line interface"
  homepage "https://www.gatsbyjs.org/docs/gatsby-cli/"
  # gatsby-cli should only be updated every 10 releases on multiples of 10
  url "https://registry.npmjs.org/gatsby-cli/-/gatsby-cli-4.20.0.tgz"
  sha256 "65050bb6a7c8723e4c8230d4b6e0674c9c0f16ce896be8289753a1d5a4ed4236"
  license "MIT"

  bottle do
    sha256                               arm64_monterey: "b5d8185fda5d34f9a6f9a0ac75d0f77743366d7d57609961de388a7d28a443af"
    sha256                               arm64_big_sur:  "18291d2cf80063b4962e3bf06aa14802f274126de518689ab6cdabb73c11e359"
    sha256                               monterey:       "4691d2e739ef997ceba4eec5e39a49c4c142179375372260cb2539f49913491d"
    sha256                               big_sur:        "e25c2e96f157ccc309c05cdccae6480ecc41d1bbbf21c7bb3004fdc7fe249af7"
    sha256                               catalina:       "ef671aebec48405ddb3a8e9a0130388c3b098e31916503aeb3c0aeec6637b977"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "260bd63f2ff145aa18a48ccef962bc9799b29e4b14e645729215b354705ae4e9"
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
