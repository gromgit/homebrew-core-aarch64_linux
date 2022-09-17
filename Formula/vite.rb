require "language/node"

class Vite < Formula
  desc "Next generation frontend tooling. It's fast!"
  homepage "https://vitejs.dev/"
  url "https://registry.npmjs.org/vite/-/vite-3.1.2.tgz"
  sha256 "45703e9ec51bd2fe59d1430fbb670e3c9aa171d39259633dd77b1188d3405a12"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6e4948d900884dc481c55a8444e46aea2e0b5bc046910994f736269ba4b05a87"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6e4948d900884dc481c55a8444e46aea2e0b5bc046910994f736269ba4b05a87"
    sha256 cellar: :any_skip_relocation, monterey:       "f3e9028e667ebd29bf4310abfac0ec2b257bb50054ba31d630b2858cf9fd9942"
    sha256 cellar: :any_skip_relocation, big_sur:        "f3e9028e667ebd29bf4310abfac0ec2b257bb50054ba31d630b2858cf9fd9942"
    sha256 cellar: :any_skip_relocation, catalina:       "f3e9028e667ebd29bf4310abfac0ec2b257bb50054ba31d630b2858cf9fd9942"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "08e9c2d298ac671a6c33176cb368d8ba5f64f576ab2ff44afaca58162b1c7d2e"
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
