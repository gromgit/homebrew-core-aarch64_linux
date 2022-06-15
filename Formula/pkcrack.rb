class Pkcrack < Formula
  desc "Implementation of an algorithm for breaking the PkZip cipher"
  homepage "https://web.archive.org/web/20220128084028/https://www.unix-ag.uni-kl.de/~conrad/krypto/pkcrack.html"
  url "https://web.archive.org/web/20140725082030/https://www.unix-ag.uni-kl.de/~conrad/krypto/pkcrack/pkcrack-1.2.2.tar.gz"
  mirror "https://pkg.freebsd.org/ports-distfiles/pkcrack-1.2.2.tar.gz"
  sha256 "4d2dc193ffa4342ac2ed3a6311fdf770ae6a0771226b3ef453dca8d03e43895a"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/pkcrack"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "e1176ee81e99612b92528b2c1383d9a85a01f27bba01102d1ee29800965a2dc8"
  end

  deprecate! date: "2022-03-30", because: :unmaintained # and upstream site is gone

  conflicts_with "csound", because: "both install `extract` binaries"
  conflicts_with "libextractor", because: "both install `extract` binaries"

  def install
    # Fix "fatal error: 'malloc.h' file not found"
    # Reported 18 Sep 2017 to conrad AT unix-ag DOT uni-kl DOT de
    ENV.prepend "CPPFLAGS", "-I#{MacOS.sdk_path}/usr/include/malloc"

    system "make", "-C", "src/"
    bin.install Dir["src/*"].select { |f| File.executable? f }
  end

  test do
    shell_output("#{bin}/pkcrack", 1)
  end
end
