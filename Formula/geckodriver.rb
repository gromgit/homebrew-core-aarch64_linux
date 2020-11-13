class Geckodriver < Formula
  desc "WebDriver <-> Marionette proxy"
  homepage "https://github.com/mozilla/geckodriver"
  license "MPL-2.0"
  head "https://hg.mozilla.org/mozilla-central/", using: :hg

  stable do
    # Get the hg_revision for stable releases from https://github.com/mozilla/geckodriver/releases
    hg_revision = "c00d2b6acd3fb1b197b25662fba0a96c11669b66"
    url "https://hg.mozilla.org/mozilla-central/archive/#{hg_revision}.zip/testing/geckodriver/"
    version "0.28.0"
    sha256 "278b0f57b4659c82a22be260e754a38d0e61fc28cb76bf8a4b672020456c2f08"

    resource "webdriver" do
      url "https://hg.mozilla.org/mozilla-central/archive/#{hg_revision}.zip/testing/webdriver/"
      sha256 "eddf228980cd00a357f549435e5225a7d291305583c1d5010b0930039f6ddfb7"
    end

    resource "mozbase" do
      url "https://hg.mozilla.org/mozilla-central/archive/#{hg_revision}.zip/testing/mozbase/rust/"
      sha256 "1049fa9f18ffc7bb03da0523d782c6f52f12bdee8b5ee3d705ee618a1e95011e"
    end

    resource "Cargo.lock" do
      url "https://hg.mozilla.org/mozilla-central/raw-file/#{hg_revision}/Cargo.lock"
      sha256 "e2b6ba6af118d2fde12cdc05dfd0feca0d1d583f8bd083255dd48544fd416ca9"
    end
  end

  livecheck do
    url "https://github.com/mozilla/geckodriver.git"
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "bd5e9db1c72e65e9af516a5c8bc43c8896808b636b036b1467447418cb34a235" => :catalina
    sha256 "d4d308dede5f3762694b6da1d21426e470bc8973b8e0084e1a44272b9673204d" => :mojave
    sha256 "c1ccd105a99db9ad2cdbba28d2502ff3a215479e83248b419c44799c0ee68dec" => :high_sierra
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
