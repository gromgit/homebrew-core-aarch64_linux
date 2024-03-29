class Gost < Formula
  desc "GO Simple Tunnel - a simple tunnel written in golang"
  homepage "https://github.com/ginuerzh/gost"
  url "https://github.com/ginuerzh/gost/archive/v2.11.4.tar.gz"
  sha256 "aa3211282fce695584795fac20da77a2ac68d3e08602118afb0747bd64c1eac4"
  license "MIT"
  head "https://github.com/ginuerzh/gost.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/gost"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "3dfa0e9a1524fb40524fbcd3a0c25b97ee1293bd1df680c23fa9c848dfad7a59"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "./cmd/gost"
    prefix.install "README_en.md"
  end

  test do
    bind_address = "127.0.0.1:#{free_port}"
    fork do
      exec "#{bin}/gost -L #{bind_address}"
    end
    sleep 2
    output = shell_output("curl -I -x #{bind_address} https://github.com")
    assert_match %r{HTTP/\d+(?:\.\d+)? 200}, output
    assert_match %r{Proxy-Agent: gost/#{version}}i, output
    assert_match(/Server: GitHub.com/i, output)
  end
end
