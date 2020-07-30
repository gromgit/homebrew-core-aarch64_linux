class Geckodriver < Formula
  desc "WebDriver <-> Marionette proxy"
  homepage "https://github.com/mozilla/geckodriver"
  license "MPL-2.0"
  head "https://hg.mozilla.org/mozilla-central/", using: :hg

  stable do
    # Get the hg_revision for stable releases from https://github.com/mozilla/geckodriver/releases
    hg_revision = "90ec81285ff6287cb2824b29ddebb7818cc7b96b"
    url "https://hg.mozilla.org/mozilla-central/archive/#{hg_revision}.zip/testing/geckodriver/"
    version "0.27.0"
    sha256 "06d92c830016edd9c4f88c9a659343fd9c35cae168820f6808f5486b3e42456f"

    resource "webdriver" do
      url "https://hg.mozilla.org/mozilla-central/archive/#{hg_revision}.zip/testing/webdriver/"
      sha256 "88ceccaba4df4ba57bdf3c9238a9834695fb51d67b749e37e1c158662ea2a6ef"
    end

    resource "mozbase" do
      url "https://hg.mozilla.org/mozilla-central/archive/#{hg_revision}.zip/testing/mozbase/rust/"
      sha256 "65c723351868f2a8b2c8dc7cb72b06ed0372dbef34ca21420162cf870c4f8b5a"
    end

    resource "Cargo.lock" do
      url "https://hg.mozilla.org/mozilla-central/raw-file/#{hg_revision}/Cargo.lock"
      sha256 "cb3d9f8f6daa3bc5cb884312c03cbd25fc754e7899c6c3ed90c452d1a90cb6ae"
    end
  end

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "2b9a2eb29b8199df3f0c8e3a4395337fcdd1ae00cea28970df0add10a36b94ce" => :catalina
    sha256 "13dd973454d187da00ccd4ab24f72987ea47f4984caa2e1fa5b3c36273d96bfa" => :mojave
    sha256 "2e57ba33554f7b0180873d49dc8dc1b1587e9c8d637d8f50146395dcb923afea" => :high_sierra
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
