class Iperf < Formula
  desc "Tool to measure maximum TCP and UDP bandwidth"
  homepage "https://sourceforge.net/projects/iperf2/"
  url "https://downloads.sourceforge.net/project/iperf2/iperf-2.1.3.tar.gz"
  sha256 "d3a30ce7522f0ae6afaadd9b0b4375938b0b0b48e827163148773496c91e9320"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(%r{url=.*?/iperf[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "d7cb2118e915fb26add136ecd34ae01640cfac4a88995aaa5b9c4b43ed58fed5"
    sha256 cellar: :any_skip_relocation, big_sur:       "4de3b6eb51e2b07ce9e17e14bc4a3910d30724f92ea638bab8c4432aa9ca35f3"
    sha256 cellar: :any_skip_relocation, catalina:      "27d6c19f6aed53b840469f13c313176fcff9dec60a822d8b5313136dabae9565"
    sha256 cellar: :any_skip_relocation, mojave:        "34bf83971e9544ca56a0f134d4f332f136dc8e186ad493e837f1a1c89cbd045e"
  end

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    server = IO.popen("#{bin}/iperf --server")
    sleep 1
    assert_match "Bandwidth", pipe_output("#{bin}/iperf --client 127.0.0.1 --time 1")
  ensure
    Process.kill("SIGINT", server.pid)
    Process.wait(server.pid)
  end
end
