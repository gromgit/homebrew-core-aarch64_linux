class TerraformLs < Formula
  desc "Terraform Language Server"
  homepage "https://github.com/hashicorp/terraform-ls"
  url "https://github.com/hashicorp/terraform-ls/archive/v0.18.0.tar.gz"
  sha256 "37d9bbf36a9c4a181c16135abe3c45853d6672a3667ebb93dd7950a7950045fa"
  license "MPL-2.0"
  head "https://github.com/hashicorp/terraform-ls.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "190f4272f21d53223928581e3ee706345a47953a830b80c6045cb3ef64d6ac2b"
    sha256 cellar: :any_skip_relocation, big_sur:       "2b7250fd75d247202f91855cfabbc1619ccccf91c81915746770a1d25e76d22d"
    sha256 cellar: :any_skip_relocation, catalina:      "108de3132f89e4a6d0f1900f4ae763f5f96f195cc5324508920993f5fb646138"
    sha256 cellar: :any_skip_relocation, mojave:        "22f385591d71b0043b8aeba796d4063fde1173c8fa0acbe74bac366604bcc3a4"
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
