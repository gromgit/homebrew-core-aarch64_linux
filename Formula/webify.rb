class Webify < Formula
  desc "Wrapper for shell commands as web services"
  homepage "https://github.com/beefsack/webify"
  url "https://github.com/beefsack/webify/archive/v1.5.0.tar.gz"
  sha256 "66805a4aef4ed0e9c49e711efc038e2cd4e74aa2dc179ea93b31dc3aa76e6d7b"
  license "MIT"
  head "https://github.com/beefsack/webify.git"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args
  end

  test do
    port = free_port
    fork do
      exec bin/"webify", "-addr=:#{port}", "cat"
    end
    sleep 1
    assert_equal "Homebrew", shell_output("curl -s -d Homebrew http://localhost:#{port}")
  end
end
