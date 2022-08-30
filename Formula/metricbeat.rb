class Metricbeat < Formula
  desc "Collect metrics from your systems and services"
  homepage "https://www.elastic.co/beats/metricbeat"
  url "https://github.com/elastic/beats.git",
      tag:      "v8.4.1",
      revision: "fe210d46ebc339459e363ac313b07d4a9ba78fc7"
  license "Apache-2.0"
  head "https://github.com/elastic/beats.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "00079a0eac799e7f33d88e79f817e7fdad5ee49cff21a76d17e9fb08e11bd9c6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "acc7108a2c9ce436f0803844f14f034f2c4cf13dd8f9abbf3a40861b5ef0c118"
    sha256 cellar: :any_skip_relocation, monterey:       "ae0a4702147f80a2f0fe34ff419ad20935cf17f0e844e3be6a708c8c4ee5ff08"
    sha256 cellar: :any_skip_relocation, big_sur:        "41e30fb473412c9ff8ba8d83ccfc99a5a924d0cb866c11e846ac02c35dc36e6a"
    sha256 cellar: :any_skip_relocation, catalina:       "08fe33429b608c9588b0406757fe601800668c82a1518e25a7b4e2ac13981c14"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3e5ee0e764f8ef6d1e3b8ca582265514f963924c3cced4b56c94bd6fff7408c3"
  end

  depends_on "go" => :build
  depends_on "mage" => :build
  depends_on "python@3.10" => :build

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

    sleep 15

    output = JSON.parse((testpath/"data/meta.json").read)
    assert_includes output, "first_start"

    (testpath/"data").glob("metricbeat-*.ndjson") do |file|
      s = JSON.parse(file.read.lines.first.chomp)
      assert_match "metricbeat", s["@metadata"]["beat"]
    end
  end
end
