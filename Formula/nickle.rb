class Nickle < Formula
  desc "Desk calculator language"
  homepage "https://www.nickle.org/"
  url "https://www.nickle.org/release/nickle-2.90.tar.gz"
  sha256 "fbb3811aa0ac4b31e1702ea643dd3a6a617b2516ad6f9cfab76ec2779618e5a4"
  license "MIT"

  livecheck do
    url "https://www.nickle.org/release/"
    regex(/href=.*?nickle[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/nickle"
    sha256 aarch64_linux: "0e9590398e7daf4c2ec157b21649950366bd507e4b2a168e0cdc358142ad402c"
  end

  depends_on "readline"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_equal "4", shell_output("#{bin}/nickle -e '2+2'").chomp
  end
end
