class Promtail < Formula
  desc "Log agent for Loki"
  homepage "https://grafana.com/loki"
  url "https://github.com/grafana/loki/archive/v2.1.0.tar.gz"
  sha256 "ceccc4e42a7158ca0bc49903a3fbe31c8cd55f85f50bac8a8bba9843b4f8cd6f"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "52202671f43f8d1ec401277ebe505f4a454699394b17a063827ab9a6a0c90eaf" => :big_sur
    sha256 "468eb2985bef79ea0fc3e1297130388154a3ab0245d1f52e1c6d31ce8bd3f27b" => :catalina
    sha256 "03701ed2836ac34136b3ca18e11260378492c730da4b45e5b92f78c08c3aa04d" => :mojave
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
