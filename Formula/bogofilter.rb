class Bogofilter < Formula
  desc "Mail filter via statistical analysis"
  homepage "https://bogofilter.sourceforge.io"
  url "https://downloads.sourceforge.net/project/bogofilter/bogofilter-stable/bogofilter-1.2.5.tar.xz"
  sha256 "3248a1373bff552c500834adbea4b6caee04224516ae581fb25a4c6a6dee89ea"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/bogofilter"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "5a152ea0f9d204bebc05ec9fbd90423b79f57e9345e3ea2dd6452ed8d9fd33a8"
  end


  depends_on "berkeley-db"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/bogofilter", "--version"
  end
end
