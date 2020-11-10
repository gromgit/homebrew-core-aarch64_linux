class TerraformLs < Formula
  desc "Terraform Language Server"
  homepage "https://github.com/hashicorp/terraform-ls"
  url "https://github.com/hashicorp/terraform-ls/archive/v0.9.0.tar.gz"
  sha256 "df01dcec0f97f6fbc8ec35368b837d3c670a799cc4feb1c20056041b20c6cd1a"
  license "MPL-2.0"
  head "https://github.com/hashicorp/terraform-ls.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "013b9d96ab8b2f22f72d025becfd27da3aaaee3d2acfc69300fe771331e44098" => :catalina
    sha256 "ab174cdab609d514e3d5bdd0a7f4ba865bc08b1bc8dfb1303a5f7fe16a59d543" => :mojave
    sha256 "664bca369e7abd7fec5e5e44bc8bd7146f3611f0df8e878d298d839a7d09de1e" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "-ldflags", "-s -w"
  end

  test do
    port = free_port

    pid = fork do
      exec "#{bin}/terraform-ls serve -port #{port} /dev/null"
    end
    sleep 2

    begin
      tcp_socket = TCPSocket.new("localhost", port)
      tcp_socket.puts <<~EOF
        Content-Length: 59

        {"jsonrpc":"2.0","method":"initialize","params":{},"id":1}
      EOF
      assert_match "Content-Type", tcp_socket.gets("\n")
    ensure
      Process.kill("SIGINT", pid)
      Process.wait(pid)
    end
  end
end
