class Par < Formula
  desc "Paragraph reflow for email"
  homepage "http://www.nicemice.net/par/"
  url "http://www.nicemice.net/par/Par-1.53.0.tar.gz"
  sha256 "c809c620eb82b589553ac54b9898c8da55196d262339d13c046f2be44ac47804"

  bottle do
    cellar :any_skip_relocation
    rebuild 2
    sha256 "9862bdce3a73b66ac07515ddc63190f9ac112a022b04d8caae3a78dbb18cc0d2" => :catalina
    sha256 "5f35670c248a421d3b8d4605ea689d3d40f2a9a902d91a3ad8b5d6802564d4cf" => :mojave
    sha256 "a73f538602df2f35f6d10b8a50fb893a26b407e5e5bc2e2065c9c2b9bcdce668" => :high_sierra
    sha256 "efa3ba3bdd3b34ad8e5089b8cd5562d8b8cf4a5e5488e54e43dfb45760a1b4fa" => :sierra
    sha256 "3683d5918dc91fcd073fc8e35af2fca416b3756aff8479ff549598bcd2500e8b" => :el_capitan
    sha256 "cb1042ef12ead6645653775571ebe84798b707194922030563ff4056687954e3" => :yosemite
  end

  conflicts_with "rancid", :because => "both install `par` binaries"

  def install
    system "make", "-f", "protoMakefile"
    bin.install "par"
    man1.install gzip("par.1")
  end

  test do
    expected = "homebrew\nhomebrew\n"
    assert_equal expected, pipe_output("#{bin}/par 10gqr", "homebrew homebrew")
  end
end
