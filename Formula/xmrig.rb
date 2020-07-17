class Xmrig < Formula
  desc "Monero (XMR) CPU miner"
  homepage "https://github.com/xmrig/xmrig"
  url "https://github.com/xmrig/xmrig/archive/v6.3.0.tar.gz"
  sha256 "ec8136637c19f07c29fd1526c4194e52007f48c46f76194fe43a71fbbb73712c"
  license "GPL-3.0"
  head "https://github.com/xmrig/xmrig.git"

  bottle do
    sha256 "69e018ecd5a617de07c4a37f54b10e81e079338c4b032e82211695f2aba5cc7b" => :catalina
    sha256 "6fb39ff00cf89948cb3c34d72d7c96d8bc891e762ab7daf280e680e471834e99" => :mojave
    sha256 "a10ebc69a3eb231fa3dbe80da557a7a94f1cb361d1bec86e2f3cafbd16b556f0" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "hwloc"
  depends_on "libmicrohttpd"
  depends_on "libuv"
  depends_on "openssl@1.1"

  def install
    mkdir "build" do
      system "cmake", "..", "-DWITH_CN_GPU=OFF", *std_cmake_args
      system "make"
      bin.install "xmrig"
    end
    pkgshare.install "src/config.json"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/xmrig -V")
    test_server="donotexist.localhost:65535"
    timeout=10
    begin
      read, write = IO.pipe
      pid = fork do
        exec "#{bin}/xmrig", "--no-color", "--max-cpu-usage=1", "--print-time=1",
             "--threads=1", "--retries=1", "--url=#{test_server}", :out => write
      end
      start_time=Time.now
      loop do
        assert (Time.now - start_time <= timeout), "No server connect after timeout"
        break if read.gets.include? "#{test_server} DNS error: \"unknown node or service\""
      end
    ensure
      Process.kill("SIGINT", pid)
    end
  end
end
