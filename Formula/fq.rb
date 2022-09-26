class Fq < Formula
  desc "Brokered message queue optimized for performance"
  homepage "https://github.com/circonus-labs/fq"
  url "https://github.com/circonus-labs/fq/archive/v0.13.10.tar.gz"
  sha256 "fe304987145ec7ce0103a3d06a75ead38ad68044c0f609ad0bcc20c06cbfd62e"
  license "MIT"
  head "https://github.com/circonus-labs/fq.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/fq"
    sha256 aarch64_linux: "a5d1a4e2adca752698d72f864b4999191c7e244bb41a880e55d159c264cd5350"
  end

  depends_on "concurrencykit"
  depends_on "jlog"
  depends_on "openssl@1.1"

  uses_from_macos "sqlite"

  on_linux do
    depends_on "util-linux"
  end

  def install
    ENV.append_to_cflags "-DNO_BCD=1"
    inreplace "Makefile", "-lbcd", ""
    inreplace "Makefile", "/usr/lib/dtrace", "#{lib}/dtrace"
    system "make", "PREFIX=#{prefix}"
    args = ["PREFIX=#{prefix}"]
    args << "ENABLE_DTRACE=0" unless OS.mac?
    system "make", "install", *args
    bin.install "fqc", "fq_sndr", "fq_rcvr"
  end

  test do
    pid = fork { exec sbin/"fqd", "-D", "-c", testpath/"test.sqlite" }
    sleep 10
    begin
      assert_match "Circonus Fq Operational Dashboard", shell_output("curl 127.0.0.1:8765")
    ensure
      Process.kill 9, pid
      Process.wait pid
    end
  end
end
