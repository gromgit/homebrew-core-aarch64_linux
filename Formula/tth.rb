class Tth < Formula
  desc "TeX/LaTeX to HTML converter"
  homepage "http://hutchinson.belmont.ma.us/tth/"
  url "http://hutchinson.belmont.ma.us/tth/tth_distribution/tth_4.15.tgz"
  sha256 "83c1f39fbf3377fb43e3d01d042302fa91f8758aa9acc10e22fe8af140f0126c"

  livecheck do
    url "http://hutchinson.belmont.ma.us/tth/Version"
    regex(/"v?(\d+(?:\.\d+)+)"/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/tth"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "43db05ea4ee476f7bf5897589b3f0749c84cb23f842bb053b38287e812ff90e2"
  end

  def install
    system ENV.cc, "-o", "tth", "tth.c"
    bin.install %w[tth latex2gif ps2gif ps2png]
    man1.install "tth.1"
  end

  test do
    assert_match(/version #{version}/, pipe_output("#{bin}/tth", ""))
  end
end
