require "language/node"

class Vite < Formula
  desc "Next generation frontend tooling. It's fast!"
  homepage "https://vitejs.dev/"
  url "https://registry.npmjs.org/vite/-/vite-3.1.4.tgz"
  sha256 "41fc29c0cac34eba99d38dfcfc87ee6dd618e7cb6728d826dc00592404ef0de5"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5efc85f7f9744f2a4c798c18f3ebc03df8de0edd97715e0cbe3c92c106b22aa1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5efc85f7f9744f2a4c798c18f3ebc03df8de0edd97715e0cbe3c92c106b22aa1"
    sha256 cellar: :any_skip_relocation, monterey:       "230f45df4ae30d1f59f892b93add495baca4f07e93a32cc8d887be9b1c3c7214"
    sha256 cellar: :any_skip_relocation, big_sur:        "230f45df4ae30d1f59f892b93add495baca4f07e93a32cc8d887be9b1c3c7214"
    sha256 cellar: :any_skip_relocation, catalina:       "230f45df4ae30d1f59f892b93add495baca4f07e93a32cc8d887be9b1c3c7214"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1e62547312f4bd0b39e2c0810bf81c5b0ea1e0d94519ef77a29dc8dc4c696b07"
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
