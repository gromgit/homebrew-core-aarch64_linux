class DosboxX < Formula
  desc "DOSBox with accurate emulation and wide testing"
  homepage "https://dosbox-x.com/"
  url "https://github.com/joncampbell123/dosbox-x/archive/dosbox-x-v0.83.7.tar.gz"
  sha256 "9cdfa3267c340a869255d8eb1c4ebf4adde47c22854e1d013da22190350bfbb3"
  license "GPL-2.0-or-later"
  version_scheme 1
  head "https://github.com/joncampbell123/dosbox-x.git"

  livecheck do
    url :head
    regex(/^dosbox-x[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    cellar :any
    sha256 "f3d52b6a99b578c8dc02530c1290a0575936aea80214def6fe3154fe4b74d2a8" => :catalina
    sha256 "dccd97558936e0440d2bcef887a240a6cfb6923456024db468be9bb334d17457" => :mojave
    sha256 "92ad3b19fc21972bac01d5a4ac0123762c21890bb0dad2de5de829f04d24442b" => :high_sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build
  depends_on "fluid-synth"
  depends_on macos: :high_sierra # needs futimens

  def install
    ENV.cxx11

    args = %W[
      --prefix=#{prefix}
      --disable-dependency-tracking
      --disable-sdltest
    ]
    system "./build-macosx", *args
    system "make", "install"
  end

  test do
    assert_match /DOSBox-X version #{version}/, shell_output("#{bin}/dosbox-x -version 2>&1", 1)
  end
end
