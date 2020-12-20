class Dmalloc < Formula
  desc "Debug versions of system memory management routines"
  homepage "https://dmalloc.com/"
  url "https://dmalloc.com/releases/dmalloc-5.6.2.tgz"
  sha256 "00e6be4af0a96cf089527323c13ecc52e60e833da38b91961d129d491d1104e3"
  license "ISC"

  bottle do
    cellar :any_skip_relocation
    sha256 "e1ff3b750a369957c46b920f34eb45ae11c4ee504c0f0ec8a832bc957335f347" => :big_sur
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
