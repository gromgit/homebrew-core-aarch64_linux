require "language/node"

class Vite < Formula
  desc "Next generation frontend tooling. It's fast!"
  homepage "https://vitejs.dev/"
  url "https://registry.npmjs.org/vite/-/vite-2.6.13.tgz"
  sha256 "b367474fe1bcb825acc5b74fffc05837e71f9be6b7b4e2319a4aa900005e9d7c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6ea46e45f8bd140b5126fba16c9029a37f22528dbb0b0a30ace678555d14d508"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "57cf4d4f8e1b40ac5dffd14b183c8ee3214e37e0c4828d7c18d52e860e15d8d7"
    sha256 cellar: :any_skip_relocation, monterey:       "c4c597eb59eeb17fa6d6582058a6578334eef0f2bddff0ffa0f9962e8cda2194"
    sha256 cellar: :any_skip_relocation, big_sur:        "5bcc4c08ad20a36166053b6d90f0b6c017d3f70a281aca733ea84e20cf1797aa"
    sha256 cellar: :any_skip_relocation, catalina:       "c4c597eb59eeb17fa6d6582058a6578334eef0f2bddff0ffa0f9962e8cda2194"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "71bb3ab4f0c9be960327c6ba383990c78c132035601c22c33d396217ab803fd9"
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
