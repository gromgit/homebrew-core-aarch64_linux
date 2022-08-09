require "language/node"

class Vite < Formula
  desc "Next generation frontend tooling. It's fast!"
  homepage "https://vitejs.dev/"
  url "https://registry.npmjs.org/vite/-/vite-3.0.5.tgz"
  sha256 "870e18b4bd8b3010ec1a67dee12deb85eddc170101e83f31233eda0aa8130b6f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b62efc0748dc9e0f7577d80b55586cf57336bc53caad5f515d1a4ee88d845247"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b62efc0748dc9e0f7577d80b55586cf57336bc53caad5f515d1a4ee88d845247"
    sha256 cellar: :any_skip_relocation, monterey:       "b0a26cd286741090a32d084de92deb1dec5d6c1c4a891ac340894f47c95e643d"
    sha256 cellar: :any_skip_relocation, big_sur:        "b0a26cd286741090a32d084de92deb1dec5d6c1c4a891ac340894f47c95e643d"
    sha256 cellar: :any_skip_relocation, catalina:       "b0a26cd286741090a32d084de92deb1dec5d6c1c4a891ac340894f47c95e643d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6d4ac5786ad6d78e60e43968196480042dd304699882a46b81eba02f3e27dc11"
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
