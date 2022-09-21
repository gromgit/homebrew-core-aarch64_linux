class Uggconv < Formula
  desc "Universal Game Genie code converter"
  homepage "https://wyrmcorp.com/software/uggconv/index.shtml"
  url "https://wyrmcorp.com/software/uggconv/uggconv-1.0.tar.gz"
  sha256 "9a215429bc692b38d88d11f38ec40f43713576193558cd8ca6c239541b1dd7b8"

  # The homepage gives the status as "Final (will not be updated)" and it was
  # last modified on 2001-12-12.
  livecheck do
    skip "No longer developed"
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/uggconv"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "a67fa953a6dcc04b8c65b55c1e5f7ad57a924b379023f025509713dd781b3492"
  end

  def install
    system "make"
    bin.install "uggconv"
    man1.install "uggconv.1"
  end

  test do
    assert_equal "7E00CE:03    = D7DA-FE86\n",
      shell_output("#{bin}/uggconv -s 7E00CE:03")
  end
end
