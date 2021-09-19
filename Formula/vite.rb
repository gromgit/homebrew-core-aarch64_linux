require "language/node"

class Vite < Formula
  desc "Next generation frontend tooling. It's fast!"
  homepage "https://vitejs.dev/"
  url "https://registry.npmjs.org/vite/-/vite-2.5.10.tgz"
  sha256 "0900ff73b6c0553a5d7d2e6ed6464946900424e070baaa858d675972100a1bf9"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "03341a3e7c5a7304aa0f4f0054dfc9f28934589eb033397d0749e97697244e6f"
    sha256 cellar: :any_skip_relocation, big_sur:       "48ecbe0dbb2c7febdf33fbe9701a9466ff604e240df0c8e6e890936c9148336a"
    sha256 cellar: :any_skip_relocation, catalina:      "48ecbe0dbb2c7febdf33fbe9701a9466ff604e240df0c8e6e890936c9148336a"
    sha256 cellar: :any_skip_relocation, mojave:        "48ecbe0dbb2c7febdf33fbe9701a9466ff604e240df0c8e6e890936c9148336a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "72ad05f6be2ba3aa39cd753fbcf275f98d7d6d9ade827a284890ceb07cbabef3"
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
