class Libupnp < Formula
  desc "Portable UPnP development kit"
  homepage "https://pupnp.sourceforge.io/"
  url "https://github.com/pupnp/pupnp/releases/download/release-1.14.5/libupnp-1.14.5.tar.bz2"
  sha256 "227ffa407be6b91d4e42abee1dd27e4b8d7e5ba8d3d45394cca4e1eadc65149a"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(/^release[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "442183f8a3b818a78bdf61f7c8f570428222c9e29cb1c05d558995d3b6a5f2f5"
    sha256 cellar: :any, big_sur:       "03342b7244d40c4c29cbee728188da749b54973b4341d5cc65e152ad28b3f7b3"
    sha256 cellar: :any, catalina:      "22be8335b2cae7ea2400aedc18e8de3e97546b8fc0a6a5ce9bb3525a0edbf081"
    sha256 cellar: :any, mojave:        "976d36ef89fa0f5dd45a3804841d9434a0c385aa642a8b2142f116f65c8d8a5e"
  end

  def install
    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --prefix=#{prefix}
      --enable-ipv6
    ]

    system "./configure", *args
    system "make", "install"
  end
end
