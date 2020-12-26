class Asio < Formula
  desc "Cross-platform C++ Library for asynchronous programming"
  homepage "https://think-async.com/Asio"
  url "https://downloads.sourceforge.net/project/asio/asio/1.18.1%20%28Stable%29/asio-1.18.1.tar.bz2"
  sha256 "4af9875df5497fdd507231f4b7346e17d96fc06fe10fd30e2b3750715a329113"
  license "BSL-1.0"
  head "https://github.com/chriskohlhoff/asio.git"

  livecheck do
    url :stable
    regex(%r{url=.*?Stable.*?/asio[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    cellar :any
    sha256 "733b954f4a2bc7121cce761a00d0c2b9996e4126d26bd226103da779d55c1f8a" => :big_sur
    sha256 "5822c0287d74cb0452f8b4bc62543fcb76e0b13cd6cdc90e4b048f116d7e5219" => :catalina
    sha256 "0c49ab2ea69cec8127b14d48995169f0c053c4727057368c568607fc08bc1198" => :mojave
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "openssl@1.1"

  def install
    ENV.cxx11

    if build.head?
      cd "asio"
      system "./autogen.sh"
    else
      system "autoconf"
    end

    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--with-boost=no"
    system "make", "install"
    pkgshare.install "src/examples"
  end

  test do
    found = Dir[pkgshare/"examples/cpp{11,03}/http/server/http_server"]
    raise "no http_server example file found" if found.empty?

    port = free_port
    pid = fork do
      exec found.first, "127.0.0.1", port.to_s, "."
    end
    sleep 1
    begin
      assert_match /404 Not Found/, shell_output("curl http://127.0.0.1:#{port}")
    ensure
      Process.kill 9, pid
      Process.wait pid
    end
  end
end
