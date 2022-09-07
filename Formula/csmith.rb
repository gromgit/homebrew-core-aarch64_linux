class Csmith < Formula
  desc "Generates random C programs conforming to the C99 standard"
  homepage "https://embed.cs.utah.edu/csmith/"
  url "https://embed.cs.utah.edu/csmith/csmith-2.3.0.tar.gz"
  sha256 "f247cc0aede5f8a0746271b40a5092b5b5a2d034e5e8f7a836c879dde3fb65d5"
  license "BSD-2-Clause"
  head "https://github.com/csmith-project/csmith.git", branch: "master"

  livecheck do
    url :homepage
    regex(/href=.*?csmith[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/csmith"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "ae9d11386faf53ed2ee0bbab346017c5cf34d5b6dfeda49e7dce94c28b52dee4"
  end

  uses_from_macos "m4" => :build

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-big_sur.diff"
    sha256 "35acd6aebc19843f1a2b3a63e880baceb0f5278ab1ace661e57a502d9d78c93c"
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "install"
    mv "#{bin}/compiler_test.in", share
    (include/"csmith-#{version}/runtime").install Dir["runtime/*.h"]
  end

  def caveats
    <<~EOS
      It is recommended that you set the environment variable 'CSMITH_PATH' to
        #{include}/csmith-#{version}
    EOS
  end

  test do
    system "#{bin}/csmith", "-o", "test.c"
  end
end
