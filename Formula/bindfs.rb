class Bindfs < Formula
  desc "FUSE file system for mounting to another location"
  homepage "https://bindfs.org/"
  url "https://bindfs.org/downloads/bindfs-1.14.4.tar.gz"
  sha256 "87a168d0198d76793149bb0fae18679aa602352ec649b53dd96f048ff01264ee"

  bottle do
    cellar :any
    sha256 "31afc14d75ff131ffad66b27964fca8e2418083643551b3c807a114e0160aaad" => :catalina
    sha256 "eeb5bd2a82f3b341cc2d48041eb1fe8f7d6b1e6c3680c3b379d5410153bff81b" => :mojave
    sha256 "3abc77e861ed4733449cb4999befe2619239bb15d0562b5c288ab7894849ca3e" => :high_sierra
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
