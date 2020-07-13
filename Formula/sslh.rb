class Sslh < Formula
  desc "Forward connections based on first data packet sent by client"
  homepage "https://www.rutschle.net/tech/sslh.shtml"
  url "https://www.rutschle.net/tech/sslh/sslh-v1.21.tar.gz"
  sha256 "a79de489a204b7a33cfd7633f4ad0eef38437f7077ab9eec9a3ded4db51da6aa"
  license "GPL-2.0"
  head "https://github.com/yrutschle/sslh.git"

  bottle do
    cellar :any
    sha256 "be0c707c6a1216bc06da14003f0af6197ac450a2fe4b6b6ce12b3e614b54fbca" => :catalina
    sha256 "cee0f6398a940312dd3198dda55d949955aa1374cd15fb5841c0446c67508e4d" => :mojave
    sha256 "b1d1ea3c654defbd69cc850ecb9b5b97b09e3b8c991faf48cb22d4190e0791b6" => :high_sierra
    sha256 "8a4b0d4715358a714c8f3ef86496e91416bcfe70067f3d71db30f97616b71080" => :sierra
  end

  depends_on "libconfig"
  depends_on "pcre"

  def install
    ENV.deparallelize
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    listen_port = free_port
    target_port = free_port

    fork do
      exec sbin/"sslh", "--http=localhost:#{target_port}", "--listen=localhost:#{listen_port}", "--foreground"
    end

    sleep 1
    system "nc", "-z", "localhost", listen_port
  end
end
