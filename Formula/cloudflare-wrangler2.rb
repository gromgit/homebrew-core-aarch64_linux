require "language/node"

class CloudflareWrangler2 < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https://github.com/cloudflare/wrangler2"
  url "https://registry.npmjs.org/wrangler/-/wrangler-2.6.2.tgz"
  sha256 "f2a5a803db8c5e8eaa2d75affc12330deb8cef33ec01c29bbc0ebdb3bb3b4985"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/cloudflare-wrangler2"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "36c360de06587d72a6a7f21e04c15684921667bb2553e3403c21ce9b1f8c0e21"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/wrangler2"]

    # Replace universal binaries with their native slices
    deuniversalize_machos libexec/"lib/node_modules/wrangler/node_modules/fsevents/fsevents.node"
  end

  test do
    system "#{bin}/wrangler2", "init", "--yes"
    assert_predicate testpath/"wrangler.toml", :exist?
    assert_match "wrangler", (testpath/"package.json").read

    assert_match "dry-run: exiting now.", shell_output("#{bin}/wrangler2 publish --dry-run")
  end
end
