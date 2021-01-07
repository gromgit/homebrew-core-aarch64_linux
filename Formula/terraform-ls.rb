class TerraformLs < Formula
  desc "Terraform Language Server"
  homepage "https://github.com/hashicorp/terraform-ls"
  url "https://github.com/hashicorp/terraform-ls/archive/v0.12.0.tar.gz"
  sha256 "371a10a7de0b8fd172b86be36ab720f8d512507b97cff41c64b67aa721b3c9fe"
  license "MPL-2.0"
  head "https://github.com/hashicorp/terraform-ls.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "6f16bd864634135cdf9db9db07cbbb24ef1f1a7165707b4aed736b97376998d6" => :big_sur
    sha256 "b42f94ad98ba2a95b9a68326adee1f0f0e6aba040a6134b694d4c3188089ae35" => :arm64_big_sur
    sha256 "49be1f2b0720b75a357f62294a1435d9911153752791bf187220be7d35b41f4b" => :catalina
    sha256 "e929d98b6ec3f7ded0f52a4509591a91dd4a61f7d2419432540e5254443e6e8b" => :mojave
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
