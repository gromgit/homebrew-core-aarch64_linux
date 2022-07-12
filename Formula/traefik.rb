class Traefik < Formula
  desc "Modern reverse proxy"
  homepage "https://traefik.io/"
  url "https://github.com/traefik/traefik/releases/download/v2.8.1/traefik-v2.8.1.src.tar.gz"
  sha256 "27c79c8fef47e51bad0a76edc9ca32d61eb11f39b57622c3add0d994fb721edb"
  license "MIT"
  head "https://github.com/traefik/traefik.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f412c9919062b5036b608dca6dddc8724b355fda9402edffb29271a1242cb3b9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fef71945c1bde2c194b26f17122b0bde01c15c8c838170475527b47af4970663"
    sha256 cellar: :any_skip_relocation, monterey:       "b5f024a97f9225933b05f10bff9a52290d9136ee1168ae523af9b70157b4ea2f"
    sha256 cellar: :any_skip_relocation, big_sur:        "3931c79c0a8f8fdfda9c3eb683f9d4778d357da138e14029ac8b1caed9c0d9c2"
    sha256 cellar: :any_skip_relocation, catalina:       "a09068091a01639437d79610bca679877604c2a93c9a59d68fa1a462081772e0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ebeb443b8351cc3782d73f7bf7a83db0510da3d9a677759703fb34c644a223d8"
  end

  depends_on "go" => :build
  depends_on "go-bindata" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/traefik/traefik/v#{version.major}/pkg/version.Version=#{version}
    ].join(" ")
    system "go", "generate"
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/traefik"
  end

  service do
    run [opt_bin/"traefik", "--configfile=#{etc}/traefik/traefik.toml"]
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
