class Metricbeat < Formula
  desc "Collect metrics from your systems and services"
  homepage "https://www.elastic.co/beats/metricbeat"
  url "https://github.com/elastic/beats.git",
      tag:      "v8.3.2",
      revision: "45f722f492dcf1d13698c6cf618b339b1d4907be"
  license "Apache-2.0"
  head "https://github.com/elastic/beats.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b296101e7ffe06b7eb44f138bd9cbbd7815fc825cf2993cc3d84be80f0744b02"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "041d1eb961067c36182e5d619b501c8c5386c1e3fe54ca46d95e4262b8fec265"
    sha256 cellar: :any_skip_relocation, monterey:       "e907cd319682ec469464994a9f10d40e3759b1a697c1c412e9119bdc348b109e"
    sha256 cellar: :any_skip_relocation, big_sur:        "704ba22304a9e21f8e565a324fb1de2b011563d28f4a3cab5d2c5e2b8c1d4450"
    sha256 cellar: :any_skip_relocation, catalina:       "4747fe2fa3f790e812e5f60b73406351d85b34303c250412397375d90447d5a9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5d74f7837911b1f1b27d0c7cf4fef54f55fba0fac61b57ee8ca9e9c3e4153cec"
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
