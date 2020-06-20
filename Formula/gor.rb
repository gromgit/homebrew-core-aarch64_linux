class Gor < Formula
  desc "Real-time HTTP traffic replay tool written in Go"
  homepage "https://gortool.com"
  revision 1
  head "https://github.com/buger/goreplay.git"

  stable do
    url "https://github.com/buger/goreplay.git",
      :tag      => "v1.0.0",
      :revision => "a8cfaa75812ac176b253ffe1d11eb9bbc7be7522"

    resource "gopacket" do
      url "https://github.com/google/gopacket/archive/v1.1.17.tar.gz"
      sha256 "12baa5a471f7eb586be2852b6d46350fe48b474fdf78524ec340638543a4912c"
    end
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "1cc0f5704bffaefa783c86f00b93747bfc56d672456ab1500d976dc55820d13e" => :catalina
    sha256 "cdc9aa443d7e1cd5408bd9bfd4b58a97bcb1bbde957191abaa41a5ecd372d475" => :mojave
    sha256 "22acfc827f96ae4f9f7e7de5f3d3741f76871767f9656747e800a7ede3a076dd" => :high_sierra
  end

  depends_on "go" => :build

  uses_from_macos "libpcap"

  def install
    if build.stable?
      ENV["GOPATH"] = buildpath

      # The vendored version of gopacket fails to build with Go 1.12+ due to the following issue, so replace
      # it with a newer version: https://github.com/google/gopacket/issues/656
      rm_rf "vendor/github.com/google/gopacket"
      (buildpath/"src/github.com/buger/goreplay").install buildpath.children
      resource("gopacket").stage buildpath/"src/github.com/buger/goreplay/vendor/github.com/google/gopacket"
      cd "src/github.com/buger/goreplay"
    end
    system "go", "build", "-ldflags", "-X main.VERSION=#{version}", *std_go_args
  end

  test do
    test_port = free_port
    fork do
      exec bin/"gor", "file-server", ":#{test_port}"
    end

    sleep 2
    system "nc", "-z", "localhost", test_port
  end
end
