class Bindfs < Formula
  desc "FUSE file system for mounting to another location"
  homepage "https://bindfs.org/"
  url "https://bindfs.org/downloads/bindfs-1.14.6.tar.gz"
  sha256 "9cf7b653951aeafa951eefe68bf6ae7d4b4652ede324209cb37b720de90ca638"

  bottle do
    cellar :any
    sha256 "5058a244ccff7948afdd5e2e09c9c9b30f0d1f16d832912312a0e50e1b55bdd8" => :catalina
    sha256 "b7dabe6b50cbfeab3e9d18ea0f29ac55220ac11a2e095b21a0ff0fe857f2e1a0" => :mojave
    sha256 "c6ab23256f69f3296c2a7b49891fabd665911b6f92b5e67c241040e134f76184" => :high_sierra
  end

  head do
    url "https://github.com/mpartel/bindfs.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on :osxfuse

  def install
    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --prefix=#{prefix}
    ]

    if build.head?
      system "./autogen.sh", *args
    else
      system "./configure", *args
    end

    system "make", "install"
  end

  test do
    system "#{bin}/bindfs", "-V"
  end
end
