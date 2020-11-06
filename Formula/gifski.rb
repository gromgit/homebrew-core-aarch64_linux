class Gifski < Formula
  desc "Highest-quality GIF encoder based on pngquant"
  homepage "https://gif.ski/"
  url "https://github.com/ImageOptim/gifski/archive/1.2.3.tar.gz"
  sha256 "52d87342125220a5d7552097adcfa43c12455709c32b4a52b27d56523a94de67"
  license "AGPL-3.0-only"
  revision 1

  bottle do
    cellar :any
    sha256 "b7278a9ef66ad5d2e0b4a57891894818d6642d55ebe7d7f99112a08928817f59" => :catalina
    sha256 "fd33e8576d6576fba097c71a57f938442180e0324cdd0b6134de3dbe0eb54173" => :mojave
    sha256 "8144380182c06069e9aadf524ac9573c0bf3e4ea69571bb9c3b385c86b3ad5a5" => :high_sierra
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "ffmpeg"

  def install
    system "cargo", "install", "--features=video", *std_cargo_args
  end

  test do
    png = test_fixtures("test.png")
    system bin/"gifski", "-o", "out.gif", png, png
    assert_predicate testpath/"out.gif", :exist?
    refute_predicate (testpath/"out.gif").size, :zero?
  end
end
