class Viewvc < Formula
  desc "Browser interface for CVS and Subversion repositories"
  homepage "http://www.viewvc.org"
  url "https://github.com/viewvc/viewvc/releases/download/1.2.1/viewvc-1.2.1.tar.gz"
  sha256 "afbc2d35fc0469df90f5cc2e855a9e99865ae8c22bf21328cbafcb9578a23e49"
  license "BSD-2-Clause"

  bottle do
    sha256 aarch64_linux: "45492fb95de6a5adad25722737543da5f5b1b1b0a26c1816138fb9b43673ab37" # fake aarch64_linux
  end

  depends_on :macos # Due to Python 2 (https://github.com/viewvc/viewvc/issues/138)

  def install
    system "python", "./viewvc-install", "--prefix=#{libexec}", "--destdir="
    Pathname.glob(libexec/"bin/*") do |f|
      next if f.directory?

      bin.install_symlink f => "viewvc-#{f.basename}"
    end
  end

  test do
    port = free_port

    begin
      pid = fork do
        exec "#{bin}/viewvc-standalone.py", "--port=#{port}"
      end
      sleep 2

      output = shell_output("curl -s http://localhost:#{port}/viewvc")
      assert_match "[ViewVC] Repository Listing", output
    ensure
      Process.kill "SIGTERM", pid
      Process.wait pid
    end
  end
end
