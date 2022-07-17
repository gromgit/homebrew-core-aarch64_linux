class Asio < Formula
  desc "Cross-platform C++ Library for asynchronous programming"
  homepage "https://think-async.com/Asio"
  url "https://downloads.sourceforge.net/project/asio/asio/1.22.2%20%28Stable%29/asio-1.22.2.tar.bz2"
  sha256 "776bb781eee8022a3eed71de28f05bf8ba09741db2e57ad8cc420aa0884cbc6c"
  license "BSL-1.0"
  head "https://github.com/chriskohlhoff/asio.git", branch: "master"

  livecheck do
    url :stable
    regex(%r{url=.*?Stable.*?/asio[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "1773aecd9c44d0809d41b366077d373ba5dd3c9744d893781354688d854562eb"
    sha256 cellar: :any,                 arm64_big_sur:  "d68afb7c39e98f18f94fc0904a8ba8177ec54bc2ee1842ffcebcabac5aeb390e"
    sha256 cellar: :any,                 monterey:       "0d4b2e8d1622d360f32dc35200e034d7d1d54718a91755227e5f2ae630da96a6"
    sha256 cellar: :any,                 big_sur:        "75273b50ad4246511b3f3980f657a4b695ced63270b839884bda21cde0eb7c15"
    sha256 cellar: :any,                 catalina:       "c53c6dae2288924630d7349d714d1c1ca803e609269d33a60c671916c1c02a04"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6263dc3ea91618ba50a05da33771e44ef5f19119d6f9ecc7ac252726a66f01a6"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "openssl@1.1"

  # Tarball is missing `src/examples/cpp20`, which causes error:
  # config.status: error: cannot find input file: `src/examples/cpp20/Makefile.in'
  # TODO: Remove in the next release
  patch :DATA

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
      assert_match "404 Not Found", shell_output("curl http://127.0.0.1:#{port}")
    ensure
      Process.kill 9, pid
    end
  end
end

__END__
diff --git a/configure.ac b/configure.ac
index 56365c2..84045ba 100644
--- a/configure.ac
+++ b/configure.ac
@@ -241,4 +241,4 @@ AC_OUTPUT([
   src/examples/cpp11/Makefile
   src/examples/cpp14/Makefile
   src/examples/cpp17/Makefile
-  src/examples/cpp20/Makefile])
+])
