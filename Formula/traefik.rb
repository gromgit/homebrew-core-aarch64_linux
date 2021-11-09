class Traefik < Formula
  desc "Modern reverse proxy"
  homepage "https://traefik.io/"
  url "https://github.com/traefik/traefik/releases/download/v2.5.4/traefik-v2.5.4.src.tar.gz"
  sha256 "4cf1f65bf4665e08f97491f099114d659ff2785989b06f8360eeaddcc3abb728"
  license "MIT"
  head "https://github.com/traefik/traefik.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cf19486b862d897ae544b4a0686732a5e76e9f3e580eddd82c88544d4bb0143d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7172cff4b0ba6bf8f320af540dc13d55382ebc290ab35a8ac3dfbabf7c7df785"
    sha256 cellar: :any_skip_relocation, monterey:       "aaca0fa699c47b07cb31690fe4d97b09f048726ac9d9371cbd3de275271b7fb1"
    sha256 cellar: :any_skip_relocation, big_sur:        "1af4398419ad2d381a218bd53e333cedf222d5c681c51b62b4c03134e8a67cd0"
    sha256 cellar: :any_skip_relocation, catalina:       "315e547e7cd74fc8b88e86b5ced504f101044b527b46ec2b74d1ea9b5332e09a"
    sha256 cellar: :any_skip_relocation, mojave:         "df84a76e97a4df0518ff6270858b3e74d2f84a73882d62e5c2d2a066da77936b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "96d7dcddf01290005ecd88fc58ba31711e57067f9b815216411123ea1df09b4a"
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
