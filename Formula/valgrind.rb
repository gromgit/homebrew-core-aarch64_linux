class Valgrind < Formula
  desc "Dynamic analysis tools (memory, debug, profiling)"
  homepage "https://www.valgrind.org/"

  stable do
    url "https://sourceware.org/pub/valgrind/valgrind-3.16.0.tar.bz2"
    sha256 "582d5127ba56dfeaab4c6ced92a742b2921148e28a5d55055aedd8f75f1cf633"

    depends_on :maximum_macos => :high_sierra
  end

  bottle do
    sha256 "0dd94804f5b3f55831c458a6824a4b71c156eeca34687c1add0f770f4e95a01f" => :high_sierra
    sha256 "8b4d5060b34d0f2112d96a2d1e7cea3b2f441bb5ce75c71b05e09aaff100fbf3" => :sierra
  end

  head do
    url "https://sourceware.org/git/valgrind.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  # Valgrind needs vcpreload_core-*-darwin.so to have execute permissions.
  # See #2150 for more information.
  skip_clean "lib/valgrind"

  def install
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --enable-only64bit
      --build=amd64-darwin
    ]
    system "./autogen.sh" if build.head?

    system "./configure", *args
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/valgrind", "ls", "-l"
  end
end
