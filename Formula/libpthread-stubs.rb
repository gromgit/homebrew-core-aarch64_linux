class LibpthreadStubs < Formula
  desc "X.Org: pthread-stubs.pc"
  homepage "https://www.x.org/"
  url "https://xcb.freedesktop.org/dist/libpthread-stubs-0.4.tar.bz2"
  sha256 "e4d05911a3165d3b18321cc067fdd2f023f06436e391c6a28dff618a78d2e733"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/libpthread-stubs"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "0e2a902d47c330837158b68c909e16dfa8887a92d4805456181f6d56f401d0b7"
  end

  depends_on "pkg-config"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "pkg-config", "--exists", "pthread-stubs"
    assert_equal 0, $CHILD_STATUS.exitstatus
  end
end
