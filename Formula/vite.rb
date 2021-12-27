require "language/node"

class Vite < Formula
  desc "Next generation frontend tooling. It's fast!"
  homepage "https://vitejs.dev/"
  url "https://registry.npmjs.org/vite/-/vite-2.7.7.tgz"
  sha256 "1daa24df90f2e1660f8282670f46c36e98d2d7a08d8768a71d245a3eb5038478"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "06152b31ffd65bdb72c251abac3705d8b88e59b102e2add2bbd9adc17798a0d3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "06152b31ffd65bdb72c251abac3705d8b88e59b102e2add2bbd9adc17798a0d3"
    sha256 cellar: :any_skip_relocation, monterey:       "5523fb23c740411bfd541c635df6cef2642d0b5982677e99d13ea7aa30359ae9"
    sha256 cellar: :any_skip_relocation, big_sur:        "5523fb23c740411bfd541c635df6cef2642d0b5982677e99d13ea7aa30359ae9"
    sha256 cellar: :any_skip_relocation, catalina:       "5523fb23c740411bfd541c635df6cef2642d0b5982677e99d13ea7aa30359ae9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a7e9c2b99160ad029256291d02ff41a4948e9c48e663b208de278281399b554c"
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
