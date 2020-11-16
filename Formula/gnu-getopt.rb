class GnuGetopt < Formula
  desc "Command-line option parsing utility"
  homepage "https://github.com/karelzak/util-linux"
  url "https://www.kernel.org/pub/linux/utils/util-linux/v2.36/util-linux-2.36.1.tar.xz"
  sha256 "09fac242172cd8ec27f0739d8d192402c69417617091d8c6e974841568f37eed"
  license "GPL-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "2e24553a1a029da4d37771a5c79c9548110ee0eb98470283e68c3c47e1188a68" => :big_sur
    sha256 "729d02eac3c092be7dec5d8d3c0f0fc813e729a94a955f1bbc56d416fc410ef1" => :catalina
    sha256 "080e1a67f6efa6ab711e300366969ae63d4b3b533bde7f5347b35c2337e20e2e" => :mojave
    sha256 "4e9566ba6ef6f6bf8f3a261ae1802f621198122e227512c65ddd9bf5d2415ab4" => :high_sierra
  end

  keg_only :provided_by_macos

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"

    system "make", "getopt"

    bin.install "getopt"
    man1.install "misc-utils/getopt.1"
    bash_completion.install "bash-completion/getopt"
  end

  test do
    system "#{bin}/getopt", "-o", "--test"
  end
end
