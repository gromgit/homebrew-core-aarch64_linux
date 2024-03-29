class Darkstat < Formula
  desc "Network traffic analyzer"
  homepage "https://unix4lyfe.org/darkstat/"
  url "https://github.com/emikulic/darkstat/archive/3.0.721.tar.gz"
  sha256 "0b405a6c011240f577559d84db22684a6349b25067c3a800df12439783c25494"
  license all_of: ["BSD-4-Clause-UC", "GPL-2.0-only", "GPL-3.0-or-later", "X11"]
  head "https://github.com/emikulic/darkstat.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/darkstat"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "5edac3f5c36c9078b1bcbb97e95a7e9b1ae280efc050d3ca998a8203e8f7bc8c"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build

  uses_from_macos "libpcap"
  uses_from_macos "zlib"

  # Patch reported to upstream on 2017-10-08
  # Work around `redefinition of clockid_t` issue on 10.12 SDK or newer
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/442ce4a5/darkstat/clock_gettime.patch"
    sha256 "001b81d417a802f16c5bc4577c3b840799511a79ceedec27fc7ff1273df1018b"
  end

  def install
    system "autoreconf", "-iv"
    system "./configure", "--disable-debug", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system sbin/"darkstat", "--verbose", "-r", test_fixtures("test.pcap")
  end
end
