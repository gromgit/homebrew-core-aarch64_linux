require "language/node"

class Vite < Formula
  desc "Next generation frontend tooling. It's fast!"
  homepage "https://vitejs.dev/"
  url "https://registry.npmjs.org/vite/-/vite-2.7.4.tgz"
  sha256 "beea2a427e7130c8a0f14663efbd1617966790b14424d7df4a888fcc2893f772"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "76df06d71424cbaf663b763fb48f2bb8ab00ae51a1f58b9fe10ed1c3c97d658a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "76df06d71424cbaf663b763fb48f2bb8ab00ae51a1f58b9fe10ed1c3c97d658a"
    sha256 cellar: :any_skip_relocation, monterey:       "6f43e5d73bccadaf1b238ec320d57329840425516e3da9ec52bc4143a308a5b6"
    sha256 cellar: :any_skip_relocation, big_sur:        "6f43e5d73bccadaf1b238ec320d57329840425516e3da9ec52bc4143a308a5b6"
    sha256 cellar: :any_skip_relocation, catalina:       "6f43e5d73bccadaf1b238ec320d57329840425516e3da9ec52bc4143a308a5b6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dabc02daaf9984c82c628ce00449f939e0cf46f4a6f2ef1a665e334750db62f5"
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
