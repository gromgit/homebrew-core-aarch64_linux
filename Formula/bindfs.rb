class Bindfs < Formula
  desc "FUSE file system for mounting to another location"
  homepage "https://bindfs.org/"
  url "https://bindfs.org/downloads/bindfs-1.14.2.tar.gz"
  sha256 "698c8d02b4e77a71e52184bd66869f4d63add4411e76636ee045d154b374c57e"

  bottle do
    cellar :any
    sha256 "787ddd3ae864e21509e1f287fdc1b63c3281605ccd2b9f50f009b442345cc4c0" => :catalina
    sha256 "f507a7ef8c0c9ee16cbc1004114957400661fcebfe8a2791bf9d95f1debd4070" => :mojave
    sha256 "f53db9e708f483ac30cf2ba9199433feb53f3fe8aa466e1dbc715860256be5bc" => :high_sierra
    sha256 "4baf7170fce17625500d6cb8ef65448de3baeaf70a17946733f567182d725c29" => :sierra
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
