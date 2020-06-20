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
    sha256 "73d9b114ff0abf11cd8f0dcde83df1c2db1921c1db8519060c9e5aec722e4b00" => :mojave
    sha256 "7ac5b35b06c5121f377b5c2e22f4c171dc245932eff1813b89af96a00eb4b42d" => :high_sierra
    sha256 "829149868a0fb7862c1ebb2d6db864e6e4730e3d7e138e638577aa8753334116" => :sierra
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
