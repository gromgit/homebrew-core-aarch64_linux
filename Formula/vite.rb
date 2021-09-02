require "language/node"

class Vite < Formula
  desc "Next generation frontend tooling. It's fast!"
  homepage "https://vitejs.dev/"
  url "https://registry.npmjs.org/vite/-/vite-2.5.3.tgz"
  sha256 "3af26eb8f2c3e978eaf1fd88d0bc878945827bd167eb0b51d25355b75f65a44a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "ae8b4809d40ed62312f3819337ab30d774a4ab6c12a6e7aeae61bdeb6c8ace53"
    sha256 cellar: :any_skip_relocation, big_sur:       "4ce20aad2ff818c5e9819514eda0f48458ba9f4a7afc018ae3d86d600c9dcc45"
    sha256 cellar: :any_skip_relocation, catalina:      "4ce20aad2ff818c5e9819514eda0f48458ba9f4a7afc018ae3d86d600c9dcc45"
    sha256 cellar: :any_skip_relocation, mojave:        "4ce20aad2ff818c5e9819514eda0f48458ba9f4a7afc018ae3d86d600c9dcc45"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "98432aaaa1e3995034ee2336aa48ed26f292b79b34c16f4d40d43d8b6a435fcd"
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
