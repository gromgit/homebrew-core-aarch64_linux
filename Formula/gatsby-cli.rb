require "language/node"

class GatsbyCli < Formula
  desc "Gatsby command-line interface"
  homepage "https://www.gatsbyjs.org/docs/gatsby-cli/"
  # gatsby-cli should only be updated every 10 releases on multiples of 10
  url "https://registry.npmjs.org/gatsby-cli/-/gatsby-cli-4.24.0.tgz"
  sha256 "1921be8b0f9fe13ff7ad2e5e731ecd00782de7a062edcbe8ae77082305469ac5"
  license "MIT"

  bottle do
    sha256                               arm64_monterey: "f047e469381dfd62938a173c037abf021db442e8a57de96484d3ebe3b4317ad8"
    sha256                               arm64_big_sur:  "695e951770094c31e36f2528f66de7ad08c514868a03b7eb4d77a63f3b0a013f"
    sha256                               monterey:       "7d1545ed1bfa41c086c3f8bfd865701870d6d715738cf275f9f4aa39dcd09961"
    sha256                               big_sur:        "5444529f0afbfa28cf9326e868d729dff9c2b75d9caf575f2b0449cf83546d4b"
    sha256                               catalina:       "1f4df8c251249cff5e4df731f3fa97f8196f0ab6ecc4a30c0ca698222feab0b5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f5b760483072c2dbe17a25758ac4e62701efaea9e2a220baf4eea1f4a355b7d2"
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
