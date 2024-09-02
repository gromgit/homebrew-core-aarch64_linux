class Clucene < Formula
  desc "C++ port of Lucene: high-performance, full-featured text search engine"
  homepage "https://clucene.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/clucene/clucene-core-unstable/2.3/clucene-core-2.3.3.4.tar.gz"
  sha256 "ddfdc433dd8ad31b5c5819cc4404a8d2127472a3b720d3e744e8c51d79732eab"
  head "https://git.code.sf.net/p/clucene/code.git", branch: "master"

  livecheck do
    url :stable
    regex(/url=.*?clucene-core[._-]v?(\d+(?:\.\d+)+[a-z]?)\.t/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/clucene"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "feda239c37c4b449916e1fcd814520bcd3cd8678d84363691b14ba2d4b9b8174"
  end

  depends_on "cmake" => :build
  uses_from_macos "zlib"

  # Portability fixes for 10.9+
  # Upstream ticket: https://sourceforge.net/p/clucene/bugs/219/
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/ec8d133/clucene/patch-src-shared-CLucene-LuceneThreads.h.diff"
    sha256 "42cb23fa6bd66ca8ea1d83a57a650f71e0ad3d827f5d74837b70f7f72b03b490"
  end

  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/ec8d133/clucene/patch-src-shared-CLucene-config-repl_tchar.h.diff"
    sha256 "b7dc735f431df409aac63dcfda9737726999eed4fdae494e9cbc1d3309e196ad"
  end

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
  end
end
