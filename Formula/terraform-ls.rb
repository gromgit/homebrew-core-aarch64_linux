class TerraformLs < Formula
  desc "Terraform Language Server"
  homepage "https://github.com/hashicorp/terraform-ls"
  url "https://github.com/hashicorp/terraform-ls/archive/v0.6.1.tar.gz"
  sha256 "9a9f10995484ad12f09d79654181f437b1a8ce17be75dbdf799a0b604e6e8375"
  license "MPL-2.0"
  head "https://github.com/hashicorp/terraform-ls.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "b3aba9b27a2293982a203924ed47c0cf58ca1f1d242fb57dfbc1b2ef21cb304a" => :catalina
    sha256 "5fb933f7dba0e21910f7ff37f0d7bca35e286e2f09b974a49c68804c7358fdd1" => :mojave
    sha256 "797540b968c723b223b50ff51c6e4204e842833094e85c4664d188840244d350" => :high_sierra
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
