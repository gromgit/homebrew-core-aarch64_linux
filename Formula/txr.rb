class Txr < Formula
  desc "Original, new programming language for convenient data munging"
  homepage "https://www.nongnu.org/txr/"
  url "http://www.kylheku.com/cgit/txr/snapshot/txr-230.tar.bz2"
  sha256 "5d4ec0f5ec919a5aa5bea93b2e7f947b4b7952303dcf0b88c06e6edc724b4b0d"
  head "http://www.kylheku.com/git/txr", :using => :git

  bottle do
    cellar :any_skip_relocation
    sha256 "1e524a37fed96ea743e315b71a087aa777c27150b9176de00749a91a1ab0d1f4" => :catalina
    sha256 "7951f53389d09a07248fff9ec2a388efa4cc61a9d6b3a976d5df15dd6114de8a" => :mojave
    sha256 "81824c3ba4c8da89b9f95eb233a297ab8ba650373f00107624c8bac57b086689" => :high_sierra
    sha256 "dc143712f1109bf6e08c0b949a55b201b9ec9610952a4e139edcbeab15c5ce67" => :sierra
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    assert_equal "3", shell_output(bin/"txr -p '(+ 1 2)'").chomp
  end
end
