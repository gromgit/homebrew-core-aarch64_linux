class Cidrmerge < Formula
  desc "CIDR merging with network exclusion"
  homepage "https://cidrmerge.sourceforge.io"
  url "https://downloads.sourceforge.net/project/cidrmerge/cidrmerge/cidrmerge-1.5.3/cidrmerge-1.5.3.tar.gz"
  sha256 "21b36fc8004d4fc4edae71dfaf1209d3b7c8f8f282d1a582771c43522d84f088"
  license "GPL-2.0"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/cidrmerge"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "20bc9dfc75d90daf9ca405e087245a8417fb39dcd488d333d6f73b29b9defdfd"
  end

  def install
    system "make"
    bin.install "cidrmerge"
  end

  test do
    input = <<~EOS
      10.1.1.0/24
      10.1.1.1/32
      192.1.4.5/32
      192.1.4.4/32
    EOS
    assert_equal "10.1.1.0/24\n192.1.4.4/31\n", pipe_output("#{bin}/cidrmerge", input)
  end
end
