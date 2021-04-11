class Fstrm < Formula
  desc "Frame Streams implementation in C"
  homepage "https://github.com/farsightsec/fstrm"
  url "https://dl.farsightsecurity.com/dist/fstrm/fstrm-0.6.1.tar.gz"
  sha256 "bca4ac1e982a2d923ccd24cce2c98f4ceeed5009694430f73fc0dcebca8f098f"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "857656667ef67ce129a655133edb97df0a5fe07f6cb562c28918283995503720"
    sha256 cellar: :any, big_sur:       "2a869068c96a6c1787a8d4f5667ed8692259b006d0e0fc37b1c1925270533ae8"
    sha256 cellar: :any, catalina:      "e84d0b8f2c27683c16e0d168a94b355cc2dcdfae2b118b943b3853579f85a829"
    sha256 cellar: :any, mojave:        "d20520e5164f271d97214c4645186996ee926c3847d59e8236e6dd643edec13b"
    sha256 cellar: :any, high_sierra:   "8a373443cef458c2384efa537867eba87a19f58a413f052dcf0ee4c6636a379b"
  end

  head do
    url "https://github.com/farsightsec/fstrm.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "libevent"

  def install
    system "autoreconf", "-fvi" if build.head?
    system "./configure", "--disable-debug",
           "--disable-dependency-tracking",
           "--disable-silent-rules",
           "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    job = fork do
      exec bin/"fstrm_capture", "-t", "protobuf:dnstap.Dnstap",
           "-u", "dnstap.sock", "-w", "capture.fstrm", "-dddd"
    end
    sleep 2
    Process.kill("TERM", job)
    system "#{bin}/fstrm_dump", "capture.fstrm"
  end
end
