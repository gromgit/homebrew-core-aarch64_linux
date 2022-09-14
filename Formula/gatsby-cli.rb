require "language/node"

class GatsbyCli < Formula
  desc "Gatsby command-line interface"
  homepage "https://www.gatsbyjs.org/docs/gatsby-cli/"
  # gatsby-cli should only be updated every 10 releases on multiples of 10
  url "https://registry.npmjs.org/gatsby-cli/-/gatsby-cli-4.23.0.tgz"
  sha256 "c2c1e43c34898223c3a349f4d94420cb6cc3befbb464c0a1be098ae837fc0733"
  license "MIT"

  bottle do
    sha256                               arm64_monterey: "5d9f1d9ac41eccdab3cd9630f79451635759382ba7b314ab39f0b640c7d01f31"
    sha256                               arm64_big_sur:  "fc23528b1e61d71e9d26b52ba6b6e085fff1ba6b2ecc3f8049428bd8b02eb15a"
    sha256                               monterey:       "94f14b4b27b3decc6b4beb1c459b87c1e0b235db9f5ec1cbd7589ddd7292e39e"
    sha256                               big_sur:        "f9642f4e9f8f3efd121963cfe30d98588aff11bc408a195d281aabaebeea83be"
    sha256                               catalina:       "193e91c45892f6d821cacdd5da072831c46261f500c232d2982e57b8d60853dd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "10cf384be015e3014792b82a02bf21856395a316338d2d9b2d04ee9e9b49e487"
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
