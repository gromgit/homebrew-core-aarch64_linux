require "language/node"

class Vite < Formula
  desc "Next generation frontend tooling. It's fast!"
  homepage "https://vitejs.dev/"
  url "https://registry.npmjs.org/vite/-/vite-2.7.3.tgz"
  sha256 "61470085dc965c2bf3ca2b093eedc993480d1b3ba512c7e53a94bea4391c263a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9f2758f7bf46d7e4dd4c48b6dc356d4287488ccb124154d48d1b38231914b762"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9f2758f7bf46d7e4dd4c48b6dc356d4287488ccb124154d48d1b38231914b762"
    sha256 cellar: :any_skip_relocation, monterey:       "7191581d58cd2bb80573ab1179e0369d78023fc6b26c1995b9d85e954b782963"
    sha256 cellar: :any_skip_relocation, big_sur:        "7191581d58cd2bb80573ab1179e0369d78023fc6b26c1995b9d85e954b782963"
    sha256 cellar: :any_skip_relocation, catalina:       "7191581d58cd2bb80573ab1179e0369d78023fc6b26c1995b9d85e954b782963"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a8e7e091bbcf110ece68a3a5bf7a8063ab3e6bbec51fb9a39c183a24c9543f67"
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
