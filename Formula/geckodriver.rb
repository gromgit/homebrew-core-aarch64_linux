class Geckodriver < Formula
  desc "WebDriver <-> Marionette proxy"
  homepage "https://github.com/mozilla/geckodriver"
  license "MPL-2.0"
  head "https://hg.mozilla.org/mozilla-central/", using: :hg

  stable do
    # Get the hg_revision for stable releases from
    # https://searchfox.org/mozilla-central/source/testing/geckodriver/CHANGES.md
    hg_revision = "970ef713fe58cbc8a29bfb2fb452a57e010bdb08"
    url "https://hg.mozilla.org/mozilla-central/archive/#{hg_revision}.zip/testing/geckodriver/"
    version "0.29.1"
    sha256 "23176305a3795163fac81748a28459e8c5d0051f014f1e713c78980df50b9069"

    resource "webdriver" do
      url "https://hg.mozilla.org/mozilla-central/archive/#{hg_revision}.zip/testing/webdriver/"
      sha256 "8c7f7aa42f4b239846d222f617d3faf6d7805f315414e603cb8504495325b7e2"
    end

    resource "mozbase" do
      url "https://hg.mozilla.org/mozilla-central/archive/#{hg_revision}.zip/testing/mozbase/rust/"
      sha256 "3cec9cc1c2a0cc0d79b00f2c45caabbf229596b5cdc2a48c2612498073e7296b"
    end

    resource "Cargo.lock" do
      url "https://hg.mozilla.org/mozilla-central/raw-file/#{hg_revision}/Cargo.lock"
      sha256 "9e91f8b8dbb4dd7a85a6d8b7b0b6a9df3a31a22479083133f1db11dbff1cb975"
    end
  end

  livecheck do
    url "https://github.com/mozilla/geckodriver.git"
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "22254633b2eb8926074a54c4304df503d44e52ba91192aa248143df17c91fd30"
    sha256 cellar: :any_skip_relocation, big_sur:       "5e3b3b2ea70199fbfb3dc656eab997e2d99cc298579fdf03097f11ab4d046161"
    sha256 cellar: :any_skip_relocation, catalina:      "2831a5194598fa63d7c5db952c14e9a95371db0ebf0fb93c88e992181c64e36a"
    sha256 cellar: :any_skip_relocation, mojave:        "c8b8c5e4de9f8e6746b1e6a565bea4438274d021fee94d0976f8ad46092e1955"
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
