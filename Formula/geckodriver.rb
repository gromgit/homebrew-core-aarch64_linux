class Geckodriver < Formula
  desc "WebDriver <-> Marionette proxy"
  homepage "https://github.com/mozilla/geckodriver"
  head "https://hg.mozilla.org/mozilla-central/", :using => :hg

  stable do
    # Get the hg_revision for stable releases from https://github.com/mozilla/geckodriver/releases
    hg_revision = "e9783a644016aa9b317887076618425586730d73"
    url "https://hg.mozilla.org/mozilla-central/archive/#{hg_revision}.zip/testing/geckodriver/"
    version "0.26.0"
    sha256 "c5854000621938de2aac0bdc853da62539e694adcba98b61851adcbb9ce54dd3"

    resource "webdriver" do
      url "https://hg.mozilla.org/mozilla-central/archive/#{hg_revision}.zip/testing/webdriver/"
      sha256 "d84d6b84d4b37bb4fadda639026eca63dc61dd289bbeb3961eef1257be49266b"
    end

    resource "mozbase" do
      url "https://hg.mozilla.org/mozilla-central/archive/#{hg_revision}.zip/testing/mozbase/rust/"
      sha256 "a838ae82753aaed38eff52bd2076e47a418858be39c7dc5d833070c6ee2f7beb"
    end

    resource "Cargo.lock" do
      url "https://hg.mozilla.org/mozilla-central/raw-file/#{hg_revision}/Cargo.lock"
      sha256 "107aaf145d4840a389c2d4586660e95e3fa336a42bb9f94524f9a72c89c21d09"
    end
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "e22f2630bb243d2ff0129f1e1807a21d7564563b198f5dcb0f15f9cc2d352c21" => :catalina
    sha256 "dc64495740d253d396aa2be1442dbcab5ad82b95b37f28c65eb724394e302ea7" => :mojave
    sha256 "aa4813eced6f47bf448a0f19ff1f73abc109122613a92aef6b217237020eba01" => :high_sierra
  end

  depends_on "rust" => :build

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
      system "cargo", "install", "--locked", "--root", prefix, "--path", "."
    end
    bin.install_symlink bin/"geckodriver" => "wires"
  end

  test do
    system bin/"geckodriver", "--help"
  end
end
