class Picat < Formula
  desc "Simple, and yet powerful, logic-based multi-paradigm programming language"
  homepage "http://picat-lang.org/"
  url "http://picat-lang.org/download/picat30_5_src.tar.gz"
  version "3.0#5"
  sha256 "ea230479b31e207a94b2800d2688d9b798a2353910f871001835723ce472ddb0"
  license "MPL-2.0"

  livecheck do
    url "http://picat-lang.org/download.html"
    regex(/>\s*?Released version v?(\d+(?:[.#]\d+)+)\s*?,/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:  "73253b90dec9024d0c9c035488314f78af4fbc469528fe6c1056cc6d733847d3"
    sha256 cellar: :any_skip_relocation, catalina: "4d90c10fb6dce3de3ac942f7e9c659ce88490b9414e041a6d8d205b950c8e058"
    sha256 cellar: :any_skip_relocation, mojave:   "905dbeb4d7a5ae69043c64fcff70474053d6084d6148e253aee6f3018e3c5d74"
  end

  def install
    system "make", "-C", "emu", "-f", "Makefile.mac64"
    bin.install "emu/picat" => "picat"
    prefix.install "lib" => "pi_lib"
    doc.install Dir["doc/*"]
    pkgshare.install "exs"
  end

  test do
    output = shell_output("#{bin}/picat #{pkgshare}/exs/euler/p1.pi").chomp
    assert_equal "Sum of all the multiples of 3 or 5 below 1000 is 233168", output
  end
end
