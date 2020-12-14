class Fq < Formula
  desc "Brokered message queue optimized for performance"
  homepage "https://github.com/circonus-labs/fq"
  url "https://github.com/circonus-labs/fq/archive/v0.13.4.tar.gz"
  sha256 "1ec2e6293d092c0a2b560a5bd325488d1ae11f7c571494192792abf300549420"
  license "MIT"
  head "https://github.com/circonus-labs/fq.git"

  bottle do
    sha256 "3bc955f57c9dd9181f8a71d7c5ad5f257bad9d8e3c22e04210ef4616757434b7" => :big_sur
    sha256 "cca321d03043680c3e666e064a22ea8dc68ee65e239160393356f96713b48c47" => :catalina
    sha256 "d0b2de2159e496bbe939ad72a64ce637551787cb44a4e822372e33c049ee3f6f" => :mojave
    sha256 "58c430bd24667e0209009d9b3aae0c1fc07e857dc16ec5f19c9b568afeba0d68" => :high_sierra
  end

  depends_on "concurrencykit"
  depends_on "jlog"
  depends_on "openssl@1.1"

  def install
    ENV.append_to_cflags "-DNO_BCD=1"
    inreplace "Makefile", "-lbcd", ""
    inreplace "Makefile", "/usr/lib/dtrace", "#{lib}/dtrace"
    system "make", "PREFIX=#{prefix}"
    system "make", "install", "PREFIX=#{prefix}"
    bin.install "fqc", "fq_sndr", "fq_rcvr"
  end

  test do
    pid = fork { exec sbin/"fqd", "-D", "-c", testpath/"test.sqlite" }
    sleep 10
    begin
      assert_match /Circonus Fq Operational Dashboard/, shell_output("curl 127.0.0.1:8765")
    ensure
      Process.kill 9, pid
      Process.wait pid
    end
  end
end
