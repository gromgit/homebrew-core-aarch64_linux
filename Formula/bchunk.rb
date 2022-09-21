class Bchunk < Formula
  desc "Convert CD images from .bin/.cue to .iso/.cdr"
  homepage "http://he.fi/bchunk/"
  url "http://he.fi/bchunk/bchunk-1.2.2.tar.gz"
  sha256 "e7d99b5b60ff0b94c540379f6396a670210400124544fb1af985dd3551eabd89"
  license "GPL-2.0"
  head "https://github.com/hessu/bchunk.git", branch: "master"

  livecheck do
    url :homepage
    regex(/href=.*?bchunk[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/bchunk"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "c66d38f2c773f4a17354f5f4636bf26d97c78b708ef2e04aca67f4c9f974cce5"
  end

  def install
    system "make"
    bin.install "bchunk"
    man1.install "bchunk.1"
  end

  test do
    (testpath/"foo.cue").write <<~EOS
      foo.bin BINARY
      TRACK 01 MODE1/2352
      INDEX 01 00:00:00
    EOS

    touch testpath/"foo.bin"

    system "#{bin}/bchunk", "foo.bin", "foo.cue", "foo"
    assert_predicate testpath/"foo01.iso", :exist?
  end
end
