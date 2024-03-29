class Ghostunnel < Formula
  desc "Simple SSL/TLS proxy with mutual authentication"
  homepage "https://github.com/ghostunnel/ghostunnel"
  url "https://github.com/ghostunnel/ghostunnel/archive/refs/tags/v1.6.1.tar.gz"
  sha256 "7fb1f9e8f60a6128b8b49cb2d3749b5fafad7d1d8c422adad48f34e240a8be6a"
  license "Apache-2.0"
  head "https://github.com/ghostunnel/ghostunnel.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/ghostunnel"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "9eea78d73d20da7574aa3d50d6b665f17e6d5b7a9cce8ed66786088ce3ab3bfe"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}")
  end

  test do
    port = free_port
    fork do
      exec bin/"ghostunnel", "client", "--listen=localhost:#{port}", "--target=localhost:4",
        "--disable-authentication", "--shutdown-timeout=1s", "--connect-timeout=1s"
    end
    sleep 1
    shell_output("curl -o /dev/null http://localhost:#{port}/", 56)
  end
end
