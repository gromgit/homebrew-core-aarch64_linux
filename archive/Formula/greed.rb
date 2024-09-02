class Greed < Formula
  desc "Game of consumption"
  homepage "http://www.catb.org/~esr/greed/"
  url "http://www.catb.org/~esr/greed/greed-4.2.tar.gz"
  sha256 "702bc0314ddedb2ba17d4b55d873384a1606886e8d69f35ce67f6e3024a8d3fd"
  license "BSD-2-Clause"
  head "https://gitlab.com/esr/greed.git", branch: "master"

  livecheck do
    url :homepage
    regex(/href=.*?greed[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/greed"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "158a87623a56f0c5f02479793b405742aff93e916b33a01727cc4ab0f5ebda2c"
  end

  uses_from_macos "ncurses"

  def install
    # Handle hard-coded destination
    inreplace "Makefile", "/usr/share/man/man6", man6
    # Make doesn't make directories
    bin.mkpath
    man6.mkpath
    (var/"greed").mkpath
    # High scores will be stored in var/greed
    system "make", "SFILE=#{var}/greed/greed.hs"
    system "make", "install", "BIN=#{bin}"
  end

  def caveats
    <<~EOS
      High scores will be stored in the following location:
        #{var}/greed/greed.hs
    EOS
  end

  test do
    assert_predicate bin/"greed", :executable?
  end
end
