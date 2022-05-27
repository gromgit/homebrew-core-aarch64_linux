class Metricbeat < Formula
  desc "Collect metrics from your systems and services"
  homepage "https://www.elastic.co/beats/metricbeat"
  url "https://github.com/elastic/beats.git",
      tag:      "v8.2.2",
      revision: "2f1e50cc31b960b1a975f2ebe08bd17be9a5e575"
  license "Apache-2.0"
  head "https://github.com/elastic/beats.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fea715cd3d5b511e51d65e5235b8d3a84749fd6eb342e9abd7f07e55c6985651"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f836e88661212186ffa904be38c59bb915172c25826b5c296438138ca0cc6936"
    sha256 cellar: :any_skip_relocation, monterey:       "42469092c5977a71ae2d881d1800393760e0f13942296c2f75360a3813bb04d7"
    sha256 cellar: :any_skip_relocation, big_sur:        "8626496dabde086e0635f8b2a57a1710c8a0d47ea17b87ad0f8d2436063f164d"
    sha256 cellar: :any_skip_relocation, catalina:       "7062267a1bc6221fbef5719bfb82009b9131b1c3cf217775aa800b121897c006"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "11e2065d8fd1ffa3e85fe3f303e9f98d94825272127a777586a39dde5e923fc6"
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
