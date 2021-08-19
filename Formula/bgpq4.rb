class Bgpq4 < Formula
  desc "BGP filtering automation for Cisco, Juniper, BIRD and OpenBGPD routers"
  homepage "https://github.com/bgp/bgpq4"
  url "https://github.com/bgp/bgpq4/archive/refs/tags/1.2.tar.gz"
  sha256 "413d1db6ebd394c098d2da34e8b12f44499acf008ec97e726706ab53760f7b55"
  license "BSD-2-Clause"
  head "https://github.com/bgp/bgpq4.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "c8cb48575ff747dfb16d6a439562723350e94f2af9435503e33c7a50c819b096"
    sha256 cellar: :any_skip_relocation, big_sur:       "3ed16f7427a8e609d8c3828e49fa36137e463158d842d165c024f951761bf7cb"
    sha256 cellar: :any_skip_relocation, catalina:      "ad87a2cbd75668227e7a48078f541232af953c779b20a3072072cf41e64b2219"
    sha256 cellar: :any_skip_relocation, mojave:        "f7e51d65e2f64e239a1031e79341de74f3b13e56dfcd68fb4a5dfefe018e065b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6eebdb95f521b4d0f9c8bbb794becf1f6acc32a5476d21192f07ebb094b736b1"
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
