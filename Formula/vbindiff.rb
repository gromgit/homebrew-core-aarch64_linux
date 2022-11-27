class Vbindiff < Formula
  desc "Visual Binary Diff"
  homepage "https://www.cjmweb.net/vbindiff/"
  url "https://www.cjmweb.net/vbindiff/vbindiff-3.0_beta5.tar.gz"
  sha256 "f04da97de993caf8b068dcb57f9de5a4e7e9641dc6c47f79b60b8138259133b8"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?vbindiff[._-]v?(\d+(?:\.\d+)+(?:.?beta\d+)?)\.t/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/vbindiff"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "bb0ab7f12e740bf019789ec4ddc79e4ae7d01c2709386b3dba0f43bd4187274c"
  end

  uses_from_macos "ncurses"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/vbindiff", "-L"
  end
end
