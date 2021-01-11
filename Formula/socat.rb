class Socat < Formula
  desc "SOcket CAT: netcat on steroids"
  homepage "http://www.dest-unreach.org/socat/"
  url "http://www.dest-unreach.org/socat/download/socat-1.7.4.1.tar.gz"
  sha256 "0c7e635070af1b9037fd96869fc45eacf9845cb54547681de9d885044538736d"
  license "GPL-2.0"

  livecheck do
    url "http://www.dest-unreach.org/socat/download/"
    regex(/href=.*?socat[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    cellar :any
    sha256 "0a8c1c733daff3d5bc93700bdcbfec12b2c0ce74eeca6953f0d8482e6fb98e04" => :big_sur
    sha256 "a7be64dcae6ef2ebe743840eb86d3d0dbaa4de8cc8e1154e7ded4f14130f05dd" => :arm64_big_sur
    sha256 "78e28a89b73b096849654b737ea66b730738cb24f8217c25acd71ba3cb75a70c" => :catalina
    sha256 "5f057eb82e1700ae32da92d5c114fabd6238cba21503f5eaf7190b56aaa35ded" => :mojave
    sha256 "90ee610e6e72158e5e2322ae198f48025f80b351b89029621fdf4b9861391ddb" => :high_sierra
  end

  depends_on "openssl@1.1"
  depends_on "readline"

  def install
    system "./configure", "--prefix=#{prefix}", "--mandir=#{man}"
    system "make", "install"
  end

  test do
    output = pipe_output("#{bin}/socat - tcp:www.google.com:80", "GET / HTTP/1.0\r\n\r\n")
    assert_match "HTTP/1.0", output.lines.first
  end
end
