class Metricbeat < Formula
  desc "Collect metrics from your systems and services"
  homepage "https://www.elastic.co/beats/metricbeat"
  url "https://github.com/elastic/beats.git",
      tag:      "v8.3.1",
      revision: "cff0399d80d4b1ac80f0981be846a50d1ec2b995"
  license "Apache-2.0"
  head "https://github.com/elastic/beats.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f853b594d4f274f051ae737287a046bbce3bd0ecbefa8fc53276e4f52c7264fb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e4346bec1481aeaf3768786c7300e73e808d77f34521546ce4f46183295d56db"
    sha256 cellar: :any_skip_relocation, monterey:       "f574f9014f2fd1554a17605045fb543e705d4969942658a59a781d2199344de2"
    sha256 cellar: :any_skip_relocation, big_sur:        "94735d4e8ba3aa658378b51aac32d6e7e14163984f738fe7a382d89f294f979c"
    sha256 cellar: :any_skip_relocation, catalina:       "909425777cfc16e89b7b99a6352f07aba3f9a1ab93abda7d0db4db1a1a9622a6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8f973998280744eff110ca07c35a8d081f0ee8cec52c2335965f5860fedc02e8"
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
