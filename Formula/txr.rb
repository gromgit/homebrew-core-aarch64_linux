class Txr < Formula
  desc "Original, new programming language for convenient data munging"
  homepage "https://www.nongnu.org/txr/"
  url "http://www.kylheku.com/cgit/txr/snapshot/txr-264.tar.bz2"
  sha256 "227e6e4c335f93eb0bea926785e8239b161df9d25e6fb966c7283f86fa2b8d00"
  license "BSD-2-Clause"

  livecheck do
    url "http://www.kylheku.com/cgit/txr"
    regex(/href=.*?txr[._-]v?(\d+(?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "b323529c4e616197c682431a366f00c36d8552e5051487537da8756b2a189a55"
    sha256 cellar: :any, big_sur:       "5e6f527182988d4f71071ffcb737b7e5510560abee416cfac4bfb6062de50f08"
    sha256 cellar: :any, catalina:      "17388085d17531d4dc6e8641acc1de90678b7628a42c8cbd4b8dbef28c411343"
    sha256 cellar: :any, mojave:        "851f66d94b1c0f27a6f832953c140d3ad5158b4e0378d7df040ea674aa654d06"
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
