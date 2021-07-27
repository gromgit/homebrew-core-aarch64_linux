class Txr < Formula
  desc "Original, new programming language for convenient data munging"
  homepage "https://www.nongnu.org/txr/"
  url "http://www.kylheku.com/cgit/txr/snapshot/txr-267.tar.bz2"
  sha256 "3cb2472b1cf0866169d2b29e4673ac34d8777edaff31527e5704141c12630149"
  license "BSD-2-Clause"

  livecheck do
    url "http://www.kylheku.com/cgit/txr"
    regex(/href=.*?txr[._-]v?(\d+(?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "2ecb575cb01184ebbb528a20ad64bc3940cd83b18e056d97fbc6b29d23440c86"
    sha256 cellar: :any, big_sur:       "ae26b163fca9a610f3d0bfd0100709604b6d01f9c9c7d110e4962acb6650374d"
    sha256 cellar: :any, catalina:      "15986245900bdae20271cf7d786a41ffdd2a12a10a55b2a502b3cf3a4b11c1c4"
    sha256 cellar: :any, mojave:        "6c8411925fa7bbb9f8b03a4ed460c3c8954af3e35d27d70e175f8122748a5f78"
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
