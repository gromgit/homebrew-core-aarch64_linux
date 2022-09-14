class Libfabric < Formula
  desc "OpenFabrics libfabric"
  homepage "https://ofiwg.github.io/libfabric/"
  url "https://github.com/ofiwg/libfabric/releases/download/v1.15.2/libfabric-1.15.2.tar.bz2"
  sha256 "8d050b88bee62e8512a88f5aa25f532f46bef587bc3f91022ecdb9b3b2676c7e"
  license any_of: ["BSD-2-Clause", "GPL-2.0-only"]
  head "https://github.com/ofiwg/libfabric.git", branch: "main"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/libfabric"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "20444485f28185799e4323d0045f55bff7300377eba79283a7c091ee6b61b246"
  end


  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool"  => :build

  on_macos do
    conflicts_with "mpich", because: "both install `fabric.h`"
  end

  def install
    system "autoreconf", "-fiv"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match "provider: sockets", shell_output("#{bin}/fi_info")
  end
end
