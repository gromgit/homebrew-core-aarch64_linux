class Libpst < Formula
  desc "Utilities for the PST file format"
  homepage "https://www.five-ten-sg.com/libpst/"
  url "https://www.five-ten-sg.com/libpst/packages/libpst-0.6.75.tar.gz"
  sha256 "2f9ddc4727af8e058e07bcedfa108e4555a9519405a47a1fce01e6420dc90c88"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://www.five-ten-sg.com/libpst/packages/"
    regex(/href=.*?libpst[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    cellar :any
    rebuild 1
    sha256 "158b068e4645da1b01bd850f4f9c43d294908fb119fd39ea3459cf2e5f9723e7" => :big_sur
    sha256 "6f245e65af86df879b94b2d043e9bc17dee7f1c307606d23d8aa0829524d620b" => :arm64_big_sur
    sha256 "9362205843b828388fe50aa733c114886210bbd2f2a8304f3916ecaf606e1cda" => :catalina
    sha256 "763deea9a814a76b5e5964e0de71bf27c6e22549df6ba5bec16c3e340cd1b80d" => :mojave
  end

  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "gettext"
  depends_on "libgsf"

  def install
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --disable-python
    ]

    system "./configure", *args
    system "make"
    system "make", "install"
  end

  test do
    system bin/"lspst", "-V"
  end
end
