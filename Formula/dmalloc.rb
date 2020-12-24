class Dmalloc < Formula
  desc "Debug versions of system memory management routines"
  homepage "https://dmalloc.com/"
  url "https://dmalloc.com/releases/dmalloc-5.6.3.tgz"
  sha256 "9200fb869be041df297710355d6debaeb780a7a685e3d83583fb9e7efe18985a"
  license "ISC"

  bottle do
    cellar :any_skip_relocation
    sha256 "e1ff3b750a369957c46b920f34eb45ae11c4ee504c0f0ec8a832bc957335f347" => :big_sur
    sha256 "f76a3f4d2592b9594b2fb0b47ad0389ec862c5b988bdb44302940d318695c9f5" => :arm64_big_sur
    sha256 "e1ef63a055d0c66350308872bb6041d96012e26f0715de5e1636c56f5a6fd8ff" => :catalina
    sha256 "c214b0a0d7d582a3d8229e7320f2b19c5ab4d08396fab3bf90076785f1cc0824" => :mojave
  end

  def install
    system "./configure", "--enable-threads", "--prefix=#{prefix}"
    system "make", "install", "installth", "installcxx", "installthcxx"
  end

  test do
    system "#{bin}/dmalloc", "-b", "runtime"
  end
end
