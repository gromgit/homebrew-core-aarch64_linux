require "language/node"

class Vite < Formula
  desc "Next generation frontend tooling. It's fast!"
  homepage "https://vitejs.dev/"
  url "https://registry.npmjs.org/vite/-/vite-3.0.4.tgz"
  sha256 "00c01d0f4ca96bf64837b3d943b0dbb728a938141402cca532db27139113f4cf"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f67638697fb8ed0c7f4e6188da155529f2b8608c04da7fc6674cfc4cd84af105"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f67638697fb8ed0c7f4e6188da155529f2b8608c04da7fc6674cfc4cd84af105"
    sha256 cellar: :any_skip_relocation, monterey:       "6dafdadd3fc61d5dd605b124c373fd114dd5f234f98b4a2ff833421dca423838"
    sha256 cellar: :any_skip_relocation, big_sur:        "6dafdadd3fc61d5dd605b124c373fd114dd5f234f98b4a2ff833421dca423838"
    sha256 cellar: :any_skip_relocation, catalina:       "6dafdadd3fc61d5dd605b124c373fd114dd5f234f98b4a2ff833421dca423838"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3cbb847512ff9b242e74117ca51b367897bec8fcb85335789d97584c6cd1369e"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
    deuniversalize_machos
  end

  test do
    port = free_port
    fork do
      system bin/"vite", "preview", "--port", port
    end
    sleep 2
    assert_match "Cannot GET /", shell_output("curl -s localhost:#{port}")
  end
end
