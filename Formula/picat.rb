class Picat < Formula
  desc "Simple, and yet powerful, logic-based multi-paradigm programming language"
  homepage "http://picat-lang.org/"
  url "http://picat-lang.org/download/picat326_src.tar.gz"
  version "3.2.6"
  sha256 "7954396866e3e12944c09a7ca4123f9ce5d6193caecb8899b79cfd098ada399d"
  license "MPL-2.0"

  livecheck do
    url "http://picat-lang.org/download.html"
    regex(/>\s*?Released version v?(\d+(?:[.#]\d+)+)\s*?,/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bd5e12223d3c6cb7e3d08224b02c6d34fda53a698386ff0b5404193b72173f55"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ab31529f1fc58ab02cd7a25e61400c68807a23d17151b47b500a0abcadf92481"
    sha256 cellar: :any_skip_relocation, monterey:       "02561124341a9e03ea889b6b7d10480135a49f10326ac823dd5261813eaaa37c"
    sha256 cellar: :any_skip_relocation, big_sur:        "d2d8781bd921e7ce98b0d6514486d2d5496fb346ad3c86858af5ee65d5da7071"
    sha256 cellar: :any_skip_relocation, catalina:       "0daa5399a992d85619eeccd6ec5704155654c12148a91ec7c44b4a2502fedd99"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d0752a640b02cee7ada01369ccb3f95868e946a286fbfc6edb01f049660a2295"
  end

  def install
    makefile = if OS.mac?
      "Makefile.mac64"
    else
      ENV.cxx11
      "Makefile.linux64"
    end
    system "make", "-C", "emu", "-f", makefile
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
