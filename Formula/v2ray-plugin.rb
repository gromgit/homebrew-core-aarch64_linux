class V2rayPlugin < Formula
  desc "SIP003 plugin based on v2ray for shadowsocks"
  homepage "https://github.com/shadowsocks/v2ray-plugin"
  url "https://github.com/shadowsocks/v2ray-plugin/archive/v1.3.1.tar.gz"
  sha256 "86d37a8ecef82457b4750a1af9e8d093b25ae0d32ea7dcc2ad5c0068fe2d3d74"
  license "MIT"
  head "https://github.com/shadowsocks/v2ray-plugin.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/v2ray-plugin"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "0d8c2f5422581c666544c92e53cc4c88cb86db8c42e99d3aac473742c733c067"
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-ldflags", "-X main.VERSION=v#{version}", "-o", bin/"v2ray-plugin"
  end

  test do
    server = fork do
      exec bin/"v2ray-plugin", "-localPort", "54000", "-remoteAddr", "github.com", "-remotePort", "80", "-server"
    end
    client = fork do
      exec bin/"v2ray-plugin", "-localPort", "54001", "-remotePort", "54000"
    end
    sleep 2
    begin
      system "curl", "localhost:54001"
    ensure
      Process.kill 9, server
      Process.wait server
      Process.kill 9, client
      Process.wait client
    end
  end
end
