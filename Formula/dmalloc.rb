class Dmalloc < Formula
  desc "Debug versions of system memory management routines"
  homepage "https://dmalloc.com/"
  url "https://dmalloc.com/releases/dmalloc-5.6.3.tgz"
  sha256 "9200fb869be041df297710355d6debaeb780a7a685e3d83583fb9e7efe18985a"
  license "ISC"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "9bd6d3c762ca8b60f3b625fc23647b4a16d48d5863952779a7f98aa1ac9e5e2f" => :big_sur
    sha256 "aee67c0ef1f77ddbaa9bcd68fc26877a09155d3a5f8e41a138e25edb3d6668d5" => :arm64_big_sur
    sha256 "da1c12b4bc40289030cd237a90046eea7605b6d69e34a12d23b90a55fa115c6a" => :catalina
    sha256 "35da99bbb7ee86823c2f3c75026f5b1674e2bc212a41cf8f9436fd0c4653bb89" => :mojave
  end

  def install
    system "./configure", "--enable-threads", "--prefix=#{prefix}"
    system "make", "install", "installth", "installcxx", "installthcxx"
  end

  test do
    system "#{bin}/dmalloc", "-b", "runtime"
  end
end
