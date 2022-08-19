require "language/node"

class Vite < Formula
  desc "Next generation frontend tooling. It's fast!"
  homepage "https://vitejs.dev/"
  url "https://registry.npmjs.org/vite/-/vite-3.0.9.tgz"
  sha256 "37c1036ed96d1d60c7e7ec372aebeadf596dc6e2624b0f2646a9bc8eab19cf52"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c95ac068fcb872cb4473296d5300c29368f2a83b82e039550aea4ec396cf6822"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c95ac068fcb872cb4473296d5300c29368f2a83b82e039550aea4ec396cf6822"
    sha256 cellar: :any_skip_relocation, monterey:       "ea979f4412dea30d12215b1a594d98b93ad48068dba92b8f70c2f281545773b7"
    sha256 cellar: :any_skip_relocation, big_sur:        "ea979f4412dea30d12215b1a594d98b93ad48068dba92b8f70c2f281545773b7"
    sha256 cellar: :any_skip_relocation, catalina:       "ea979f4412dea30d12215b1a594d98b93ad48068dba92b8f70c2f281545773b7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "97fe8910da727f78348b1a63a8d9f9ebc005c6c13d2050c57d65eafac7bf8882"
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
