class Pachi < Formula
  desc "Software for the Board Game of Go/Weiqi/Baduk"
  homepage "https://pachi.or.cz/"
  url "https://github.com/pasky/pachi/archive/pachi-12.60.tar.gz"
  sha256 "3c05cf4fe5206ba4cbe0e0026ec3225232261b44e9e05e45f76193b4b31ff8e9"
  license "GPL-2.0"
  head "https://github.com/pasky/pachi.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/pachi"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "6a94c3cd5d103005b2be4a91dbf0466aea2befc59a7de74e8cf3044053d57d4e"
  end

  resource "patterns" do
    url "https://sainet-dist.s3.amazonaws.com/pachi_patterns.zip"
    sha256 "73045eed2a15c5cb54bcdb7e60b106729009fa0a809d388dfd80f26c07ca7cbc"
  end

  resource "book" do
    url "https://gnugo.baduk.org/books/ra6.zip"
    sha256 "1e7ffc75c424e94338308c048aacc479da6ac5cbe77c0df8adc733956872485a"
  end

  def install
    ENV["MAC"] = "1"
    ENV["DOUBLE_FLOATING"] = "1"

    # https://github.com/pasky/pachi/issues/78
    inreplace "Makefile", "build.h: .git/HEAD .git/index", "build.h:"
    inreplace "Makefile", "DCNN=1", "DCNN=0"

    system "make"
    bin.install "pachi"

    pkgshare.install resource("patterns")
    pkgshare.install resource("book")
  end

  def caveats
    <<~EOS
      This formula also downloads additional data, such as opening books
      and pattern files. They are stored in #{opt_pkgshare}.

      At present, pachi cannot be pointed to external files, so make sure
      to set the working directory to #{opt_pkgshare} if you want pachi
      to take advantage of these additional files.
    EOS
  end

  test do
    assert_match(/^= [A-T][0-9]+$/, pipe_output("#{bin}/pachi", "genmove b\n", 0))
  end
end
