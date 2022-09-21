class Dmalloc < Formula
  desc "Debug versions of system memory management routines"
  homepage "https://dmalloc.com/"
  url "https://dmalloc.com/releases/dmalloc-5.6.5.tgz"
  sha256 "480e3414ab6cedca837721c756b7d64b01a84d2d0e837378d98444e2f63a7c01"
  license "ISC"

  livecheck do
    url "https://dmalloc.com/releases/"
    regex(/href=.*?dmalloc[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/dmalloc"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "1e7b022adc85fdffed5c88f6276b37c22b6e27558908ce505bb64e4bd0c6c2b1"
  end

  def install
    system "./configure", "--enable-threads", "--prefix=#{prefix}"
    system "make", "install", "installth", "installcxx", "installthcxx"
  end

  test do
    system "#{bin}/dmalloc", "-b", "runtime"
  end
end
