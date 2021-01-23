class Ooniprobe < Formula
  desc "Network interference detection tool"
  homepage "https://ooni.org/"
  url "https://github.com/ooni/probe-cli/archive/v3.3.0.tar.gz"
  sha256 "f5b7473a9a67ee3c4c417651359939b3933256af10bb2019b12176fb7c249c11"
  license "BSD-3-Clause"

  bottle do
    cellar :any_skip_relocation
    sha256 "d5f31d0c5073779256648854d9e758937dcaf2f01c06abfc901604820db9e571" => :big_sur
    sha256 "6d383155a1abc59e7fdc0a884945ced11d39e266f6800ad02d1a3a7826279895" => :catalina
    sha256 "c331a6eec61ac5658df3d321f145ed1616050f4091ffaba7436e3721132707f8" => :mojave
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "-ldflags", "-s -w", "./cmd/ooniprobe"
    (var/"ooniprobe").mkpath
  end

  test do
    (testpath/"config.json").write <<~EOS
      {
        "_version": 3,
        "_informed_consent": true,
        "sharing": {
          "include_ip": false,
          "include_asn": true,
          "upload_results": false
        },
        "nettests": {
          "websites_url_limit": 1,
          "websites_enabled_category_codes": []
        },
        "advanced": {
          "send_crash_reports": true,
          "collect_usage_stats": true
        }
      }
    EOS

    mkdir_p "#{testpath}/ooni_home"
    ENV["OONI_HOME"] = "#{testpath}/ooni_home"
    Open3.popen3(bin/"ooniprobe", "--config", testpath/"config.json", "run", "websites", "--batch") do |_, _, stderr|
      stderr.to_a.each do |line|
        j_line = JSON.parse(line)
        assert_equal j_line["level"], "info"
      end
    end
  end
end
