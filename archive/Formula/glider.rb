class Glider < Formula
  desc "Forward proxy with multiple protocols support"
  homepage "https://github.com/nadoo/glider"
  url "https://github.com/nadoo/glider/archive/refs/tags/v0.16.2.tar.gz"
  sha256 "a1c7032ad508b6c55dad3a356737cf05083441ea16a46c03f8548d4892ff9183"
  license "GPL-3.0-or-later"
  head "https://github.com/nadoo/glider.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/glider"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "25bc0bd0198cc92791484211a02bf2340eb6939813e75756126ecfd8d1bf8a80"
  end

  depends_on "go" => :build

  uses_from_macos "curl" => :test

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)

    etc.install buildpath/"config/glider.conf.example" => "glider.conf"
  end

  service do
    run [opt_bin/"glider", "-config", etc/"glider.conf"]
    keep_alive true
  end

  test do
    proxy_port = free_port
    glider = fork { exec "#{bin}/glider", "-listen", "socks5://:#{proxy_port}" }

    sleep 3
    begin
      assert_match "The Missing Package Manager for macOS (or Linux)",
        shell_output("curl --socks5 127.0.0.1:#{proxy_port} -L https://brew.sh")
    ensure
      Process.kill 9, glider
      Process.wait glider
    end
  end
end
