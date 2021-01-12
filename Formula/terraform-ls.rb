class TerraformLs < Formula
  desc "Terraform Language Server"
  homepage "https://github.com/hashicorp/terraform-ls"
  url "https://github.com/hashicorp/terraform-ls/archive/v0.12.1.tar.gz"
  sha256 "796577a1b9da762d284b1765a033660670ed607c62455adb3299dacbd90cdb2e"
  license "MPL-2.0"
  head "https://github.com/hashicorp/terraform-ls.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "6eacf617ede431a420d39efce2212d97e925722006ffbde85eb0b256ff81b1d7" => :big_sur
    sha256 "2a06eae4cf69eee132bb173464742a628a899c67914f3120e553fd17fd0e1c5f" => :arm64_big_sur
    sha256 "c77359b0e16af58ff89fe195fbb4bf84d772d681a404c9b0dc9c7d034fd87338" => :catalina
    sha256 "58f8c0e9ccb735c8d414ec365d4261a1c84aa8297c38d5526bf3207057e246ec" => :mojave
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
