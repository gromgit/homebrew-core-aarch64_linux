class Gauge < Formula
  desc "Test automation tool that supports executable documentation"
  homepage "https://getgauge.io"
  url "https://github.com/getgauge/gauge/archive/v1.1.0.tar.gz"
  sha256 "414d59049c5b5d9e95b62629a6914907c6b28c8431d4353bf39a1bd3d0f6d59e"
  head "https://github.com/getgauge/gauge.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "0f16a8295dbab45d8cb2ceaaf6a7edfcc06ee6b6a6a1aac861305b8abd61607c" => :catalina
    sha256 "2237331e6743d129136094e1c30e0991cc992df65c347e677d6089a868dda2d6" => :mojave
    sha256 "af217db3bd44249e7b8d18c50074529b2a7858aae22a000e65b5cc6f84fae103" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "run", "build/make.go"
    system "go", "run", "build/make.go", "--install", "--prefix", prefix
  end

  test do
    (testpath/"manifest.json").write <<~EOS
      {
        "Plugins": [
          "html-report"
        ]
      }
    EOS

    system("#{bin}/gauge install")
    assert_predicate testpath/".gauge/plugins", :exist?

    system("#{bin}/gauge config check_updates false")
    assert_match "false", shell_output("#{bin}/gauge config check_updates")

    assert_match version.to_s, shell_output("#{bin}/gauge -v 2>&1")
  end
end
