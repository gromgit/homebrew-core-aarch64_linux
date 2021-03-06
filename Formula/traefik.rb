class Traefik < Formula
  desc "Modern reverse proxy"
  homepage "https://traefik.io/"
  url "https://github.com/traefik/traefik/releases/download/v2.6.6/traefik-v2.6.6.src.tar.gz"
  sha256 "3ebb59c8286fa1138c2615de404fcc232316409da8a2046e2f7894c3c000766f"
  license "MIT"
  head "https://github.com/traefik/traefik.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/traefik"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "e7f88fabecb966f5dc08ac229dc0ef2e2df4a1436183d3bf84f8d5babb400b71"
  end

  depends_on "go" => :build
  depends_on "go-bindata" => :build

  # Fix build with Go 1.18.
  # Remove with v2.7.
  patch do
    url "https://github.com/traefik/traefik/commit/9297055ad8f651c751473b5fd4103eb224a8337e.patch?full_index=1"
    sha256 "b633710c7bde8737fbe0170066a765ee749f014d38afd06ef40085773e152fd0"
  end

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
