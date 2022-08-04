class Memcached < Formula
  desc "High performance, distributed memory object caching system"
  homepage "https://memcached.org/"
  url "https://www.memcached.org/files/memcached-1.6.16.tar.gz"
  sha256 "3051a93bf1dd0c3af2d0e589ff6ef6511f876385a35b18e9ff8741e4a1ab34da"
  license "BSD-3-Clause"
  head "https://github.com/memcached/memcached.git", branch: "master"

  livecheck do
    url :homepage
    regex(/href=.*?memcached[._-]v?(\d+(?:\.\d+){2,})\./i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "86d06a3aaadafa7d5a6cf6c3e4926766e487ff50093a0eb0adb6d50bd4ca1f8a"
    sha256 cellar: :any,                 arm64_big_sur:  "331bd4db8e0ef165c1664cecd77518e9a78c2ece981dcca872fab66ede101db8"
    sha256 cellar: :any,                 monterey:       "9c06484a7b000d69fd12870f902c220145f847b913a05214cc7266e78048436a"
    sha256 cellar: :any,                 big_sur:        "88374bf363b761e87a2b7741a7212a04140f0806df6286768c48cb6b7cba4da4"
    sha256 cellar: :any,                 catalina:       "3dc2211659ccb40df7f8bee6e8c552f3569afb13e896bb0667330ede957c26fb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ed6ef5a9c611d310dcc7f107ef466e4ba6bb03195f5c42e58f655648c25e1df6"
  end

  depends_on "libevent"

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-coverage", "--enable-tls"
    system "make", "install"
  end

  service do
    run [opt_bin/"memcached", "-l", "localhost"]
    working_dir HOMEBREW_PREFIX
    keep_alive true
    run_type :immediate
  end

  test do
    pidfile = testpath/"memcached.pid"
    port = free_port
    args = %W[
      --listen=127.0.0.1
      --port=#{port}
      --daemon
      --pidfile=#{pidfile}
    ]
    args << "--user=#{ENV["USER"]}" if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]
    system bin/"memcached", *args
    sleep 1
    assert_predicate pidfile, :exist?, "Failed to start memcached daemon"
    pid = (testpath/"memcached.pid").read.chomp.to_i
    Process.kill "TERM", pid
  end
end
