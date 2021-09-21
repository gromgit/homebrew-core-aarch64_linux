class Metricbeat < Formula
  desc "Collect metrics from your systems and services"
  homepage "https://www.elastic.co/beats/metricbeat"
  url "https://github.com/elastic/beats.git",
      tag:      "v7.14.2",
      revision: "574c21d25ddb65a63665ac26b54799f81a7e9706"
  license "Apache-2.0"
  head "https://github.com/elastic/beats.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "569cdb1f6e44931560c309921edc3ba157db5a0049475ffc54c9934678ea484d"
    sha256 cellar: :any_skip_relocation, big_sur:       "5c3977b650b1a1ce2896f57554f4f29f975107c98a0e8d3cccc91d3af2ff01ba"
    sha256 cellar: :any_skip_relocation, catalina:      "632862f28d9f6f50ccb7d63bb796b7bf3e59441b61ecb34f881b01f899ba539f"
    sha256 cellar: :any_skip_relocation, mojave:        "4df81d3569342f4074b20a27a67a7e53e0def83566900157ad60d98a7ab8fe2a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "668afd25e586b99413c3141fe3402abb5928df2d9b24b67761042e50935376c3"
  end

  depends_on "go" => :build
  depends_on "mage" => :build
  depends_on "python@3.9" => :build

  def install
    # remove non open source files
    rm_rf "x-pack"

    cd "metricbeat" do
      # don't build docs because it would fail creating the combined OSS/x-pack
      # docs and we aren't installing them anyway
      inreplace "magefile.go", "mg.Deps(CollectDocs, FieldsDocs)", ""

      system "mage", "-v", "build"
      ENV.deparallelize
      system "mage", "-v", "update"

      (etc/"metricbeat").install Dir["metricbeat.*", "fields.yml", "modules.d"]
      (libexec/"bin").install "metricbeat"
      prefix.install "build/kibana"
    end

    (bin/"metricbeat").write <<~EOS
      #!/bin/sh
      exec #{libexec}/bin/metricbeat \
        --path.config #{etc}/metricbeat \
        --path.data #{var}/lib/metricbeat \
        --path.home #{prefix} \
        --path.logs #{var}/log/metricbeat \
        "$@"
    EOS
  end

  service do
    run opt_bin/"metricbeat"
  end

  test do
    (testpath/"config/metricbeat.yml").write <<~EOS
      metricbeat.modules:
      - module: system
        metricsets: ["load"]
        period: 1s
      output.file:
        enabled: true
        path: #{testpath}/data
        filename: metricbeat
    EOS

    (testpath/"logs").mkpath
    (testpath/"data").mkpath

    fork do
      exec bin/"metricbeat", "-path.config", testpath/"config", "-path.data",
                             testpath/"data"
    end

    sleep 30
    assert_predicate testpath/"data/metricbeat", :exist?
  end
end
