require "language/node"

class Vite < Formula
  desc "Next generation frontend tooling. It's fast!"
  homepage "https://vitejs.dev/"
  url "https://registry.npmjs.org/vite/-/vite-3.0.1.tgz"
  sha256 "f4fe96cf2a124bc288dee1bac2562b2bc3bb0508475c0c80b8b3f243a334dff3"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "77600c490b97c702123bfaf9bc5a9bab55a465eaed2b6cca86102addf951b5c7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "77600c490b97c702123bfaf9bc5a9bab55a465eaed2b6cca86102addf951b5c7"
    sha256 cellar: :any_skip_relocation, monterey:       "f734c755716ffa31a07d17ebbd3bd27211f5bc4f37fb695db3861d582042cdb2"
    sha256 cellar: :any_skip_relocation, big_sur:        "f734c755716ffa31a07d17ebbd3bd27211f5bc4f37fb695db3861d582042cdb2"
    sha256 cellar: :any_skip_relocation, catalina:       "f734c755716ffa31a07d17ebbd3bd27211f5bc4f37fb695db3861d582042cdb2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f8bd4f9f0e3eb6445d1358cb85678a3a833c3f058ed642fe2166f7f0fd40bf18"
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
