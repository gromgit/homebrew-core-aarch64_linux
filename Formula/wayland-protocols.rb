class WaylandProtocols < Formula
  desc "Additional Wayland protocols"
  homepage "https://wayland.freedesktop.org"
  url "https://wayland.freedesktop.org/releases/wayland-protocols-1.22.tar.xz"
  sha256 "96e7cf03524995a47028236c6d6141c874e693cb80c0be8dabe15455cdd5a5a7"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, x86_64_linux: "f1744e0eccc76810d17efaf1d05599140667a48731ac8c1409fd4dbbab7232c6"
  end

  depends_on "pkg-config" => [:build, :test]
  depends_on "wayland" => :build
  depends_on :linux

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--sysconfdir=#{etc}",
                          "--localstatedir=#{var}",
                          "--disable-silent-rules"
    system "make"
    system "make", "install"
  end

  test do
    system "pkg-config", "--exists", "wayland-protocols"
    assert_equal 0, $CHILD_STATUS.exitstatus
  end
end
