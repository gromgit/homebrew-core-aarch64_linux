class Dmalloc < Formula
  desc "Debug versions of system memory management routines"
  homepage "https://dmalloc.com/"
  url "https://dmalloc.com/releases/dmalloc-5.6.3.tgz"
  sha256 "9200fb869be041df297710355d6debaeb780a7a685e3d83583fb9e7efe18985a"
  license "ISC"

  bottle do
    cellar :any_skip_relocation
    sha256 "b8adc88e238dd4b5ffa06bd25fbe0e5315e4d7abebe16b1b65cd3a4340a171ed" => :big_sur
    sha256 "6b8a1b0bb0087964ab24f25ab07c5a8d112c1e943b310ac0d9883d3564718eb4" => :arm64_big_sur
    sha256 "5d37429176b49fbe3b3cf0119d1187d05a6857d044fab230cd204e8934f2c754" => :catalina
    sha256 "526d21a46d7fdaa8c2b23f7b4495da92c6089ef5e95d58f7540668821f988dd1" => :mojave
  end

  def install
    system "./configure", "--enable-threads", "--prefix=#{prefix}"
    system "make", "install", "installth", "installcxx", "installthcxx"
  end

  test do
    system "#{bin}/dmalloc", "-b", "runtime"
  end
end
