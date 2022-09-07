class Picat < Formula
  desc "Simple, and yet powerful, logic-based multi-paradigm programming language"
  homepage "http://picat-lang.org/"
  url "http://picat-lang.org/download/picat316_src.tar.gz"
  version "3.1#6"
  sha256 "857f45e1a99e9d597843d0ddede82bbcbb077f7aff568ffa4ab30785dc170821"
  license "MPL-2.0"

  livecheck do
    url "http://picat-lang.org/download.html"
    regex(/>\s*?Released version v?(\d+(?:[.#]\d+)+)\s*?,/i)
  end

  bottle do
    # root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/picat"
    root_url "https://ghcr.io/v2/gromgit/core-aarch64_linux/picat"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "1f8cf0ccf6a2cf908967ab7c75255f2943849d087404808c0c6cb241f70e00db"
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
