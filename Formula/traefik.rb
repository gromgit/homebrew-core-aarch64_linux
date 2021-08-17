class Traefik < Formula
  desc "Modern reverse proxy"
  homepage "https://traefik.io/"
  url "https://github.com/traefik/traefik/releases/download/v2.4.14/traefik-v2.4.14.src.tar.gz"
  sha256 "579ce84df70fac22cbb88800001925687e7ed52571b62d6b031d1e570438e689"
  license "MIT"
  head "https://github.com/traefik/traefik.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "85226d89a43854f1812b786cd16057b9a895cead70599eec3f874cd7bca68632"
    sha256 cellar: :any_skip_relocation, big_sur:       "8553b217ad0a81ca75fa96349274305972ecdf968eb111cee2a1a9c660306466"
    sha256 cellar: :any_skip_relocation, catalina:      "3936b6374da00b97e0004340c262b80fcabd6acf4513f2554f013d8076848546"
    sha256 cellar: :any_skip_relocation, mojave:        "5328a56b3b38011233e698687c91fe510e0191143e6fa36be88dfaff9833cd60"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "669b22ce5ce5b45fe5b2ecf91d9c7593643b9412e58364471a59b1182ea07cf1"
  end

  depends_on "go" => :build
  depends_on "go-bindata" => :build

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
