require "language/node"

class GatsbyCli < Formula
  desc "Gatsby command-line interface"
  homepage "https://www.gatsbyjs.org/docs/gatsby-cli/"
  # gatsby-cli should only be updated every 10 releases on multiples of 10
  url "https://registry.npmjs.org/gatsby-cli/-/gatsby-cli-4.19.0.tgz"
  sha256 "0a4cf79160d17ff32fbc69207739f4cb24da4e204e04b1281bb66272a1a35676"
  license "MIT"

  bottle do
    sha256                               arm64_monterey: "655d79d6a2fc9771d49ed073c7d6a221c2a1252c0ea23d76d8d87bc8709ada61"
    sha256                               arm64_big_sur:  "00a418effbd33f8f0b4d2564a4d288f639bc973ef9076730ea17b8d32264f320"
    sha256                               monterey:       "3efa5b609c9d2818d9b1c00c20e4fae6b729d039da7c3304db6655bd63c0e958"
    sha256                               big_sur:        "3632d1d249c542898bf7a81981e7169920127beb736456cb880774449678d6a8"
    sha256                               catalina:       "ccded7ab89b9e78980b4c051a691d992525f0d15ddbf24ba99c2321c41660aa9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "260591ddf22377a3e97dd0aaf272963d3860f4ca4ae5f30fa701ef60d7918b40"
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
