class Goproxy < Formula
  desc "Global proxy for Go modules"
  homepage "https://github.com/goproxyio/goproxy"
  url "https://github.com/goproxyio/goproxy/archive/v2.0.7.tar.gz"
  sha256 "d87f3928467520f8d6b0ba8adcbf5957dc6eb2dc9936249edd6568ceb01a71ca"
  license "MIT"
  head "https://github.com/goproxyio/goproxy.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/goproxy"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "f9c418fc18d4f902ed8ad850dc3393a09af749a76fb6a0c34b179c575e8c9d25"
  end

  depends_on "go" => [:build, :test]

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    ENV["GOPATH"] = testpath.to_s
    bind_address = "127.0.0.1:#{free_port}"
    begin
      server = IO.popen("#{bin}/goproxy -proxy=https://goproxy.io -listen=#{bind_address}", err: [:child, :out])
      sleep 1
      ENV["GOPROXY"] = "http://#{bind_address}"
      system "go", "install", "golang.org/x/tools/cmd/guru@latest"
    ensure
      Process.kill("SIGINT", server.pid)
    end
    assert_match "200 /golang.org/x/tools/", server.read
  end
end
