class Promtail < Formula
  desc "Log agent for Loki"
  homepage "https://grafana.com/loki"
  url "https://github.com/grafana/loki/archive/v2.0.1.tar.gz"
  sha256 "f21013650bd7aa6d773e3ab842bd67423191310459022f0582f1d829e7f33f3f"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "50ea3132d8603aa26dd730b4bdaab1d4d6f291aca37343409401bace6241dd72" => :big_sur
    sha256 "266e3141851c43a8e66c8133ec783c364b9c6a78fddea261e9373b2e17dc25f8" => :catalina
    sha256 "0f8dfd4e9d043ab006f797f6ab58cb943f6f3f9bb597345260b634a48eb927f7" => :mojave
  end

  depends_on "go" => :build

  def install
    cd "cmd/promtail" do
      system "go", "build", *std_go_args
      etc.install "promtail-local-config.yaml"
    end
  end

  test do
    port = free_port

    cp etc/"promtail-local-config.yaml", testpath
    inreplace "promtail-local-config.yaml" do |s|
      s.gsub! "9080", port.to_s
      s.gsub! /__path__: .+$/, "__path__: #{testpath}"
    end

    fork { exec bin/"promtail", "-config.file=promtail-local-config.yaml" }
    sleep 3

    output = shell_output("curl -s localhost:#{port}/metrics")
    assert_match "log_messages_total", output
  end
end
