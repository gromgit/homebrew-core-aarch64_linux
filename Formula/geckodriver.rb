class Geckodriver < Formula
  desc "WebDriver <-> Marionette proxy"
  homepage "https://github.com/mozilla/geckodriver"
  license "MPL-2.0"
  head "https://hg.mozilla.org/mozilla-central/", using: :hg

  stable do
    # Get the hg_revision for stable releases from
    # https://searchfox.org/mozilla-central/source/testing/geckodriver/CHANGES.md
    hg_revision = "cf6956a5ec8e21896736f96237b1476c9d0aaf45"
    url "https://hg.mozilla.org/mozilla-central/archive/#{hg_revision}.zip/testing/geckodriver/"
    version "0.29.0"
    sha256 "26b86be8c1fe47d1a7b25ae6dfc280776567c9d48b6c7491eb0e7fcc1944a8d2"

    resource "webdriver" do
      url "https://hg.mozilla.org/mozilla-central/archive/#{hg_revision}.zip/testing/webdriver/"
      sha256 "d8579cd155aad688931361b3ca8f1e8260592641162d5e51a78b59e189e44c56"
    end

    resource "mozbase" do
      url "https://hg.mozilla.org/mozilla-central/archive/#{hg_revision}.zip/testing/mozbase/rust/"
      sha256 "d3693c78c0186b34197b1fdfd34a2694a155dc36ce0a50d5ccfc558aca54fd0b"
    end

    resource "Cargo.lock" do
      url "https://hg.mozilla.org/mozilla-central/raw-file/#{hg_revision}/Cargo.lock"
      sha256 "048970448a118b1569b9e70192c0214a86363e0c25094819d4cf6b99ee54eef0"
    end
  end

  livecheck do
    url "https://github.com/mozilla/geckodriver.git"
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "7fa8c7402cf7b076094ca1ef3286236866641530b270dda9f4e11ad2f4d93ba6" => :big_sur
    sha256 "bddeebce8c78f5d555f31a4544e96cfa2bb58f38ccdff9dc0abdc4ed6ccf0a29" => :arm64_big_sur
    sha256 "a20476cfe9b256bdceb599e58e0d8364d9407c7c83a49a9a7c7933367c14de56" => :catalina
    sha256 "06808179a65aebbddcea493ba1c6002cd0abb396473f01947a11e2789f9354d2" => :mojave
    sha256 "986d06965c069a00d36246a8d12bcf73d5869433519919e64edfc6076b236d97" => :high_sierra
  end

  depends_on "rust" => :build

  uses_from_macos "unzip"

  def install
    unless build.head?
      # we need to do this, because all archives are containing a top level testing directory
      %w[webdriver mozbase].each do |r|
        (buildpath/"staging").install resource(r)
        mv buildpath/"staging"/"testing"/r, buildpath/"testing"
        rm_rf buildpath/"staging"/"testing"
      end
      rm_rf buildpath/"staging"
      (buildpath/"testing"/"geckodriver").install resource("Cargo.lock")
    end

    cd "testing/geckodriver" do
      system "cargo", "install", *std_cargo_args
    end
    bin.install_symlink bin/"geckodriver" => "wires"
  end

  test do
    test_port = free_port
    fork do
      exec "#{bin}/geckodriver --port #{test_port}"
    end
    sleep 2

    system "nc", "-z", "localhost", test_port
  end
end
