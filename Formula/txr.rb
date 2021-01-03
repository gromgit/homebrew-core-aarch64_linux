class Txr < Formula
  desc "Original, new programming language for convenient data munging"
  homepage "https://www.nongnu.org/txr/"
  url "http://www.kylheku.com/cgit/txr/snapshot/txr-246.tar.bz2"
  sha256 "5873993746e80bb3c293ce5c650c22ddf7a089d7819aed1838df25ac12d5c794"
  license "BSD-2-Clause"

  livecheck do
    url "http://www.kylheku.com/cgit/txr"
    regex(/href=.*?txr[._-]v?(\d+)\.t/i)
  end

  bottle do
    cellar :any
    sha256 "a56a11ffa457176f369e9a09efbb13d962d4eb8f547c0791704497284acb4cf7" => :big_sur
    sha256 "e467433174a1b719f4129794c10bb07d9eb57c4b44c25863c868a0e6162215b1" => :catalina
    sha256 "f040ee03a05b1baeeba6a83a1e61c9b91b25430d44ab66519f7ee2553c1c5d43" => :mojave
  end

  depends_on "libffi"

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build

  def install
    system "./configure", "--prefix=#{prefix}", "--inline=static inline"
    system "make"
    system "make", "install"
  end

  test do
    assert_equal "3", shell_output(bin/"txr -p '(+ 1 2)'").chomp
  end
end
