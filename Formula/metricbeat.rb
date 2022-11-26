class Metricbeat < Formula
  desc "Collect metrics from your systems and services"
  homepage "https://www.elastic.co/beats/metricbeat"
  url "https://github.com/elastic/beats.git",
      tag:      "v8.5.2",
      revision: "1ebd0940bd56943642ea8d63d1fe8227f86e7435"
  license "Apache-2.0"
  head "https://github.com/elastic/beats.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ce73b5dc6631cccb8e4d2c488303a2d7d4cfecb2901741f66144b9852229bfd9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "887c5aef33e10348cce0806bb5235cc061903ab7b8594af96d449866d52bb3dc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9f43caa1ad9d5fa197de7b27b5a0bce5f1d53321efd3740ee5609ab8dcd07a76"
    sha256 cellar: :any_skip_relocation, monterey:       "fbabea32556bfddfd4eae7d789c4314a76b2b2040e718260b79e3d2fd70c72b2"
    sha256 cellar: :any_skip_relocation, big_sur:        "81146f6b6d4fb17b8a138f50c4a24f10ca4bb51c95bd8cec438cf65da42ef2f9"
    sha256 cellar: :any_skip_relocation, catalina:       "0e21f86c1a6e6efca82b456703080eabd3eee94a26382a6fb97de823f28d7a56"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b2816eefec8240c6a29c4655761eaf7ebac6eeac9cc9a7074aad661f071eb218"
  end

  depends_on "go" => :build
  depends_on "mage" => :build
  depends_on "python@3.11" => :build

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

    chmod 0555, bin/"metricbeat" # generate_completions_from_executable fails otherwise
    generate_completions_from_executable(bin/"metricbeat", "completion", shells: [:bash, :zsh])
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
