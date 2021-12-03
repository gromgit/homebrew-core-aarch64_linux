class TerraformLs < Formula
  desc "Terraform Language Server"
  homepage "https://github.com/hashicorp/terraform-ls"
  url "https://github.com/hashicorp/terraform-ls/archive/v0.25.0.tar.gz"
  sha256 "4a18351561b56436fdb621bc13551e5b1eac88f1fa0e746b23cce8de78ffa0c1"
  license "MPL-2.0"
  head "https://github.com/hashicorp/terraform-ls.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "465012bcabf6001187f106a807fe9d0fc072ab4396756475d688540c466e7f19"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0dbd6db6eadea003d51a75499e7249937f61f6a9c3fe7972231acbd628536ed4"
    sha256 cellar: :any_skip_relocation, monterey:       "9f6eb31366b537800c6ce515ceaef32fecde500d7832ae69a26a9da42b024918"
    sha256 cellar: :any_skip_relocation, big_sur:        "91a6eb4167c63367976229b5ba27a61c912ad9d639c1158e8661b453a88c3b57"
    sha256 cellar: :any_skip_relocation, catalina:       "e39b908c7e661c3e1b8123c7816b46be484f599cb4be83d0a8d326790b596046"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bc79c3d483343c0df10b92253982f1bf0b75439db42c0964cc595b9f0710872e"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
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
