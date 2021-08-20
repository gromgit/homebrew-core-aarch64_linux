class Bgpq4 < Formula
  desc "BGP filtering automation for Cisco, Juniper, BIRD and OpenBGPD routers"
  homepage "https://github.com/bgp/bgpq4"
  url "https://github.com/bgp/bgpq4/archive/refs/tags/1.4.tar.gz"
  sha256 "db4bb0e035e62f00b515529988ad8a552871dcf17ea1d32e0cbf3aae18c2602e"
  license "BSD-2-Clause"
  head "https://github.com/bgp/bgpq4.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "816ae6e069e438aa3d96c22c0f0079d09a15e87688590c20b1280a58152a1bbe"
    sha256 cellar: :any_skip_relocation, big_sur:       "6b6e75aa1810a9bb41f08c6c4728fa2b787b4b0f13f3e57a7ee65dd9dc64ea57"
    sha256 cellar: :any_skip_relocation, catalina:      "4986d84aca312d6dd1ba2234b7736943d9670142765b08dc8f123a0a23c68b89"
    sha256 cellar: :any_skip_relocation, mojave:        "d096a3f68b4a4b2ec53c2b9bf35604309f8fe4dce9fb8a30d84cff1f9c73f502"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "596499d38595e439ad347fe7174348d631e4f662339106bcf9241201dc77114c"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  def install
    system "./bootstrap"
    system "./configure", "--prefix=#{prefix}", "--mandir=#{man}"
    system "make", "install"
  end

  test do
    output = <<~EOS
      no ip prefix-list NN
      ! generated prefix-list NN is empty
      ip prefix-list NN deny 0.0.0.0/0
    EOS

    assert_match output, shell_output("#{bin}/bgpq4 AS-ANY")
  end
end
