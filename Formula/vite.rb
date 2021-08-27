require "language/node"

class Vite < Formula
  desc "Next generation frontend tooling. It's fast!"
  homepage "https://vitejs.dev/"
  url "https://registry.npmjs.org/vite/-/vite-2.5.1.tgz"
  sha256 "195adabc6953545ba0314f38467adc849ed09a1b7f709e78546bed5613dee411"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "47a9f96b9a3fc1ca21a5d3771578aad60b23fc269a291519e74a950e5a88d0aa"
    sha256 cellar: :any_skip_relocation, big_sur:       "ac643e4ae177c2e2f26bb8f9c54f44c7680d45b27de300644fbe3606f743de7b"
    sha256 cellar: :any_skip_relocation, catalina:      "ac643e4ae177c2e2f26bb8f9c54f44c7680d45b27de300644fbe3606f743de7b"
    sha256 cellar: :any_skip_relocation, mojave:        "ac643e4ae177c2e2f26bb8f9c54f44c7680d45b27de300644fbe3606f743de7b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8b9ef8d4c447f99f0f3d829953a4d29e957ff25252ad5bc946d3aeb1349b6af5"
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
