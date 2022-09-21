class Pidof < Formula
  desc "Display the PID number for a given process name"
  homepage "http://www.nightproductions.net/cli.htm"
  url "http://www.nightproductions.net/downloads/pidof_source.tar.gz"
  version "0.1.4"
  sha256 "2a2cd618c7b9130e1a1d9be0210e786b85cbc9849c9b6f0cad9cbde31541e1b8"
  license :cannot_represent

  livecheck do
    url :homepage
    regex(/href=.*?pidof[^>]+>\s*Download \(v?(\d+(?:\.\d+)+)\)</i)
  end

  bottle do
    sha256 aarch64_linux: "45492fb95de6a5adad25722737543da5f5b1b1b0a26c1816138fb9b43673ab37" # fake aarch64_linux
  end

  # Hard dependency on sys/proc.h, which isn't available on Linux
  depends_on :macos

  def install
    system "make", "all", "CC=#{ENV.cc}", "CFLAGS=#{ENV.cflags}"
    man1.install gzip("pidof.1")
    bin.install "pidof"
  end

  test do
    (testpath/"homebrew_testing.c").write <<~EOS
      #include <unistd.h>
      #include <stdio.h>

      int main()
      {
        printf("Testing Pidof\\n");
        sleep(10);
        return 0;
      }
    EOS
    system ENV.cc, "homebrew_testing.c", "-o", "homebrew_testing"
    (testpath/"homebrew_testing").chmod 0555

    pid = fork { exec "./homebrew_testing" }
    sleep 1
    begin
      assert_match(/\d+/, shell_output("#{bin}/pidof homebrew_testing"))
    ensure
      Process.kill("SIGINT", pid)
      Process.wait(pid)
    end
  end
end
