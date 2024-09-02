class TrojanGo < Formula
  desc "Trojan proxy in Go"
  homepage "https://p4gefau1t.github.io/trojan-go/"
  url "https://github.com/p4gefau1t/trojan-go.git",
      tag:      "v0.10.6",
      revision: "2dc60f52e79ff8b910e78e444f1e80678e936450"
  license "GPL-3.0-only"
  head "https://github.com/p4gefau1t/trojan-go.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/trojan-go"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "dc528317ccd2e473d9c0f4f9fda7c44596275232868cca322722213df8e34755"
  end

  depends_on "go" => :build

  resource "geoip" do
    url "https://github.com/v2fly/geoip/releases/download/202109102251/geoip.dat"
    sha256 "ca9de5837b4ac6ceeb2a3f50d0996318011c0c7f8b5e11cb1fca6a5381f30862"
  end

  resource "geoip-only-cn-private" do
    url "https://github.com/v2fly/geoip/releases/download/202109102251/geoip-only-cn-private.dat"
    sha256 "5af05c2ba255e0388f9630fcd40e05314e1cf89b8228ce4d319c45b1de36bd7c"
  end

  resource "geosite" do
    url "https://github.com/v2fly/domain-list-community/releases/download/20210910080130/dlc.dat"
    sha256 "96376220c7e78076bfde7254ee138b7c620902c7731c1e642a8ac15a74fecb34"
  end

  def install
    execpath = libexec/name
    ldflags = %W[
      -s -w
      -X github.com/p4gefau1t/trojan-go/constant.Version=v#{version}
      -X github.com/p4gefau1t/trojan-go/constant.Commit=#{Utils.git_head}
    ].join(" ")

    system "go", "build", *std_go_args(ldflags: ldflags), "-o", execpath, "-tags=full"
    (bin/"trojan-go").write_env_script execpath,
      TROJAN_GO_LOCATION_ASSET: "${TROJAN_GO_LOCATION_ASSET:-#{pkgshare}}"

    pkgetc.install "example/client.json" => "config.json"

    resource("geoip").stage do
      pkgshare.install "geoip.dat"
    end

    resource("geoip-only-cn-private").stage do
      pkgshare.install "geoip-only-cn-private.dat"
    end

    resource("geosite").stage do
      pkgshare.install "dlc.dat" => "geosite.dat"
    end
  end

  def caveats
    <<~EOS
      An example config is installed to #{etc}/trojan-go/config.json
    EOS
  end

  service do
    run [bin/"trojan-go", "-config", etc/"trojan-go/config.json"]
    run_type :immediate
    keep_alive true
  end

  test do
    require "webrick"

    (testpath/"test.crt").write <<~EOS
      -----BEGIN CERTIFICATE-----
      MIIBuzCCASQCCQDC8CtpZ04+pTANBgkqhkiG9w0BAQsFADAhMQswCQYDVQQGEwJV
      UzESMBAGA1UEAwwJbG9jYWxob3N0MCAXDTIxMDUxMDE0MjEwNFoYDzIxMjEwNDE2
      MTQyMTA0WjAhMQswCQYDVQQGEwJVUzESMBAGA1UEAwwJbG9jYWxob3N0MIGfMA0G
      CSqGSIb3DQEBAQUAA4GNADCBiQKBgQC8VJ+Gv2BRZajCUJ8LxGCGopO6w27xvwLu
      U0ztdJibWCUUYxGk7IDnhnarbpD18CnZ0bqqUvu/gn1Lod5rHUuDdh2KdMefiugR
      bu1jtKxi25kKfd+12nqph7dI9iuenroHUi5SBxCCKEQSo528/2QIeltTtBASNiKB
      CBjdIu0wjwIDAQABMA0GCSqGSIb3DQEBCwUAA4GBAGm7Lrhd7ZP91d7ezBLQZ3L/
      xciCZUmm6DcMfGgel13aI8keYID5LPUoIJ8X3uoOu2SV7r4G53mJKtyyqUKfbMBG
      DSq4rm8g2L9r5LdVYQFcvJjJxHGLMOvZUvm7NiQH1/zd73nHYhu+0yravaUkywEl
      fhs+mOABareCK+xi+YT0
      -----END CERTIFICATE-----
    EOS
    (testpath/"test.key").write <<~EOS
      -----BEGIN PRIVATE KEY-----
      MIICdwIBADANBgkqhkiG9w0BAQEFAASCAmEwggJdAgEAAoGBALxUn4a/YFFlqMJQ
      nwvEYIaik7rDbvG/Au5TTO10mJtYJRRjEaTsgOeGdqtukPXwKdnRuqpS+7+CfUuh
      3msdS4N2HYp0x5+K6BFu7WO0rGLbmQp937XaeqmHt0j2K56eugdSLlIHEIIoRBKj
      nbz/ZAh6W1O0EBI2IoEIGN0i7TCPAgMBAAECgYBRusO0PW82Q9DV6xjqiWF+bCWC
      QnfuL3+9H6dd0WC84abNzySEFyLl1wO+5+++22e+IHdKnVKlTKLFZMzaXU88UJjG
      WwQdKhLPw4MvVsPNwFtDlP+EyKfzKHlQ5PAhPjw5Hz1isE2b98JNqMbj0QMZqpES
      hm391fmfk8QPBPsLyQJBAPpWUOfJcQUC1bh0qF/XatLmg6A4DEHyhbZq/kehcvZK
      zes71uzcW1NuzDE3ahbv3IFy5UOWWWiPXD1Dp/iGBYUCQQDAlzs+rd9Uaqq4ZfdA
      iH2wkUub+2kcRi59MlH9B22Wb+VmWTqcwwhVFlKB8to/0bIsK+cae8D1VBYLhuZu
      yKADAkEAzxrYBlrOiPHGdLr2jYv/UYnpvYSBB5In8znjMsmr/Xz3jTRNZFoNqCHT
      BqisuVspl2LBr7/UKj/odLrjXSUrrQJAUIuvQnKTcYm+5qn2c23iK0NI/O5zsliD
      vuaZtZoysfUQWvK8ea1zwao5TZHUx1YbDzA5UjEprTDCm4WKwBB2IwJBANbtLRvS
      CsWbp+cEK+zSllqBhvlJQUf2DNQRGHsItbq1dbqNA3xF1WWh6IQSevN4M1exdBLa
      OOqlfB3Fyb6Mld0=
      -----END PRIVATE KEY-----
    EOS

    http_server_port = free_port
    http_server = WEBrick::HTTPServer.new Port: http_server_port
    Thread.new { http_server.start }

    trojan_go_server_port = free_port
    (testpath/"server.yaml").write <<~EOS
      run-type:     server
      local-addr:   127.0.0.1
      local-port:   #{trojan_go_server_port}
      remote-addr:  127.0.0.1
      remote-port:  #{http_server_port}
      password:
        - test
      ssl:
        cert:       #{testpath}/test.crt
        key:        #{testpath}/test.key
    EOS
    server = fork { exec "#{bin}/trojan-go", "-config", testpath/"server.yaml" }

    trojan_go_client_port = free_port
    (testpath/"client.yaml").write <<~EOS
      run-type:     client
      local-addr:   127.0.0.1
      local-port:   #{trojan_go_client_port}
      remote-addr:  127.0.0.1
      remote-port:  #{trojan_go_server_port}
      password:
        - test
      ssl:
        verify:     false
        sni:        localhost
    EOS
    client = fork { exec "#{bin}/trojan-go", "-config", testpath/"client.yaml" }

    sleep 3
    begin
      system "curl", "--socks5", "127.0.0.1:#{trojan_go_client_port}", "github.com"
    ensure
      Process.kill 9, server
      Process.wait server
      Process.kill 9, client
      Process.wait client
      http_server.shutdown
    end
  end
end
