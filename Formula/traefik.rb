class Traefik < Formula
  desc "Modern reverse proxy"
  homepage "https://traefik.io/"
  url "https://github.com/traefik/traefik/releases/download/v2.5.1/traefik-v2.5.1.src.tar.gz"
  sha256 "46e60fbab64c5ba87517caf83431149f7d076e8d6674a72a18c789672014a1a1"
  license "MIT"
  head "https://github.com/traefik/traefik.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "5da3c625f62b5481c01b8c213e85cf2da031921fc70089c487c1601b68146cc4"
    sha256 cellar: :any_skip_relocation, big_sur:       "5bdc6d92db1434337a8dd0f519d129f57eaf6b063fe0bb249dcc50f12ddf9c60"
    sha256 cellar: :any_skip_relocation, catalina:      "8104d36eed9a4e8af4ef4a1c848c64f573fa6c581e5f7cab31e2a67e835fa56c"
    sha256 cellar: :any_skip_relocation, mojave:        "f4bc956c7d2494b17e3e5aad67526279f66cf21dbae6d1b57f385646c5a3cb5b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ec273a05f4dcf5b51616c260dfe6eadc68fb33aacde792a5a2c333a1d83bf8a9"
  end

  depends_on "go" => :build
  depends_on "go-bindata" => :build

  # Support go 1.17, remove after next release
  patch do
    url "https://github.com/traefik/traefik/commit/352a72a5d7ed6caff2315f92d61f50c475c9f137.patch?full_index=1"
    sha256 "ff99dad7a1933b87c94e0bdf22eb38a69c09ffb9c4292f2112359ff1bbe3020f"
  end

  def install
    system "go", "generate"
    system "go", "build",
      "-ldflags", "-s -w -X github.com/traefik/traefik/v#{version.major}/pkg/version.Version=#{version}",
      "-trimpath", "-o", bin/"traefik", "./cmd/traefik"
  end

  service do
    run [opt_bin/"traefik", "--configfile=#{etc/"traefik/traefik.toml"}"]
    keep_alive false
    working_dir var
    log_path var/"log/traefik.log"
    error_log_path var/"log/traefik.log"
  end

  test do
    ui_port = free_port
    http_port = free_port

    (testpath/"traefik.toml").write <<~EOS
      [entryPoints]
        [entryPoints.http]
          address = ":#{http_port}"
        [entryPoints.traefik]
          address = ":#{ui_port}"
      [api]
        insecure = true
        dashboard = true
    EOS

    begin
      pid = fork do
        exec bin/"traefik", "--configfile=#{testpath}/traefik.toml"
      end
      sleep 5
      cmd_ui = "curl -sIm3 -XGET http://127.0.0.1:#{http_port}/"
      assert_match "404 Not Found", shell_output(cmd_ui)
      sleep 1
      cmd_ui = "curl -sIm3 -XGET http://127.0.0.1:#{ui_port}/dashboard/"
      assert_match "200 OK", shell_output(cmd_ui)
    ensure
      Process.kill(9, pid)
      Process.wait(pid)
    end

    assert_match version.to_s, shell_output("#{bin}/traefik version 2>&1")
  end
end
