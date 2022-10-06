require "language/node"

class Vite < Formula
  desc "Next generation frontend tooling. It's fast!"
  homepage "https://vitejs.dev/"
  url "https://registry.npmjs.org/vite/-/vite-3.1.5.tgz"
  sha256 "737012f31f2a95d737354bc8f17964087d6294f563285cd749a6f7fd1fb57669"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d3e25a6fab9c778a16f44752b44d56532a3c3f8260758a4affcd72419882cd66"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d3e25a6fab9c778a16f44752b44d56532a3c3f8260758a4affcd72419882cd66"
    sha256 cellar: :any_skip_relocation, monterey:       "cf0bc36104ec6e675cd229a7ee0f893c286394f035e1e3126095be3dc9020674"
    sha256 cellar: :any_skip_relocation, big_sur:        "cf0bc36104ec6e675cd229a7ee0f893c286394f035e1e3126095be3dc9020674"
    sha256 cellar: :any_skip_relocation, catalina:       "cf0bc36104ec6e675cd229a7ee0f893c286394f035e1e3126095be3dc9020674"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1a2d0c6324d66a787e23994a7f5cb86f6306766cc4eb18cfcb74119e87456349"
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
