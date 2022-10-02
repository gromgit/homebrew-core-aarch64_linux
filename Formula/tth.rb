class Tth < Formula
  desc "TeX/LaTeX to HTML converter"
  homepage "http://hutchinson.belmont.ma.us/tth/"
  url "http://hutchinson.belmont.ma.us/tth/tth_distribution/tth_4.16.tgz"
  sha256 "ff8b88c6dbb938f01fe6a224c396fc302ae5d89b9b6d97f207f7ae0c4e7f0a32"

  livecheck do
    url "http://hutchinson.belmont.ma.us/tth/Version"
    regex(/"v?(\d+(?:\.\d+)+)"/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/tth"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "dbc6440fd421eed4a3b864b1e583f61034ccfc1d40a9146a7c92295aa9a939b1"
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
