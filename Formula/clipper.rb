class Clipper < Formula
  desc "Share macOS clipboard with tmux and other local and remote apps"
  homepage "https://wincent.com/products/clipper"
  url "https://github.com/wincent/clipper/archive/2.0.0.tar.gz"
  sha256 "9c9fa0b198d11513777d40c88e2529b2f2f84d7045a500be5946976a5cdcfe83"
  license "BSD-2-Clause"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/clipper"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "60c2857071054b6705e50123457fc1d27c95eb3508d85e12b06d32911b7df185"
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-ldflags", "-s -w", "-trimpath", "-o", bin/"clipper", "clipper.go"
  end

  service do
    run opt_bin/"clipper"
    environment_variables LANG: "en_US.UTF-8"
    keep_alive true
    working_dir HOMEBREW_PREFIX
  end

  test do
    test_data = "a simple string! to test clipper, with söme spéciål characters!! 🐎\n".freeze

    cmd = [opt_bin/"clipper", "-a", testpath/"clipper.sock", "-l", testpath/"clipper.log"].freeze
    ohai cmd.join " "

    require "open3"
    Open3.popen3({ "LANG" => "en_US.UTF-8" }, *cmd) do |_, _, _, clipper|
      sleep 0.5 # Give it a moment to launch and create its socket.
      begin
        sock = UNIXSocket.new testpath/"clipper.sock"
        assert_equal test_data.bytesize, sock.sendmsg(test_data)
        sock.close
        sleep 0.5
        assert_equal test_data, `LANG=en_US.UTF-8 pbpaste`
      ensure
        Process.kill "TERM", clipper.pid
      end
    end
  end
end
