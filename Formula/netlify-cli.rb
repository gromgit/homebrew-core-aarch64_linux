require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-11.6.0.tgz"
  sha256 "45a40d993089bf1cb3ee084526bb248eff926e055c1d2b422b6b625c5dfa365a"
  license "MIT"
  head "https://github.com/netlify/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "19a6f7fdf7c27180e648a5b8157f09d92dd135f730788c6165b60af434fe53a7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "19a6f7fdf7c27180e648a5b8157f09d92dd135f730788c6165b60af434fe53a7"
    sha256 cellar: :any_skip_relocation, monterey:       "1e1457dd273eeac277ea940939d34208f1e26222f3d3633ff6d7d6323a6555b4"
    sha256 cellar: :any_skip_relocation, big_sur:        "1e1457dd273eeac277ea940939d34208f1e26222f3d3633ff6d7d6323a6555b4"
    sha256 cellar: :any_skip_relocation, catalina:       "1e1457dd273eeac277ea940939d34208f1e26222f3d3633ff6d7d6323a6555b4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4bce36cb185fed597902a466c03fb963549e7faaa80dc6c5397d8fa2591f353a"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match "Not logged in. Please log in to see site status.", shell_output("#{bin}/netlify status")
  end
end
