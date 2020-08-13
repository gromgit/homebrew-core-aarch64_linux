class Avfs < Formula
  desc "Virtual file system that facilitates looking inside archives"
  homepage "https://avf.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/avf/avfs/1.1.3/avfs-1.1.3.tar.bz2"
  sha256 "4f4ec1e8c0d5da94949e3dab7500ee29fa3e0dda723daf8e7d60e5f3ce4450df"

  bottle do
    sha256 "b384f9e4d2e44eb776ea56e5daa54e08caf7ed735c17717f1a81c5ded06375bc" => :catalina
    sha256 "a20fc2155f0b4392a8d417e2bd960fd8c579ec8666946e3c127be0306288e847" => :mojave
    sha256 "8ae40f6a5695d4b2e1e66db5201a524ddf2bfbfa97a45d9e72d8adb89090de7b" => :high_sierra
  end

  depends_on "pkg-config" => :build
  depends_on macos: :sierra # needs clock_gettime
  depends_on "openssl@1.1"
  depends_on :osxfuse
  depends_on "xz"

  def install
    args = %W[
      --prefix=#{prefix}
      --disable-debug
      --disable-dependency-tracking
      --disable-silent-rules
      --enable-fuse
      --enable-library
      --with-ssl=#{Formula["openssl@1.1"].opt_prefix}
    ]

    system "./configure", *args
    system "make", "install"
  end

  test do
    system bin/"avfsd", "--version"
  end
end
