class Lft < Formula
  desc "Layer Four Traceroute (LFT), an advanced traceroute tool"
  homepage "https://pwhois.org/lft/"
  url "https://pwhois.org/dl/index.who?file=lft-3.9.tar.gz"
  version "3.90"
  sha256 "dbec812eeb307b20caa88af80eb843fe7c8adde4d3a25159dad77a9f0afe040a"

  bottle do
    cellar :any_skip_relocation
    sha256 "210741a36959c0a1f953fb7ae91b38c386e3c1b8fbccae65113c97dd63c9abc0" => :catalina
    sha256 "69b8c78d246e722359143f6aee676f48eb6e45f3391b0e1bf5d11851c51a6c63" => :mojave
    sha256 "baa74dc5e37610b0e676e4bd175d631c7e9c8a1207b55d0fca1dc2bf0e070512" => :high_sierra
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match "isn't available to LFT", shell_output("#{bin}/lft -S -d 443 brew.sh 2>&1")
  end
end
