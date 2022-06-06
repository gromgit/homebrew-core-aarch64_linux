class Jemalloc < Formula
  desc "Implementation of malloc emphasizing fragmentation avoidance"
  homepage "http://jemalloc.net/"
  url "https://github.com/jemalloc/jemalloc/releases/download/5.3.0/jemalloc-5.3.0.tar.bz2"
  sha256 "2db82d1e7119df3e71b7640219b6dfe84789bc0537983c3b7ac4f7189aecfeaa"
  license "BSD-2-Clause"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/jemalloc"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "934beecfd7396fd84b87bdcd6a5a45a5d10a3083c824e1b74e2ff56e020ade4b"
  end

  head do
    url "https://github.com/jemalloc/jemalloc.git", branch: "dev"

    depends_on "autoconf" => :build
    depends_on "docbook-xsl" => :build
  end

  def install
    args = %W[
      --disable-debug
      --prefix=#{prefix}
      --with-jemalloc-prefix=
    ]

    if build.head?
      args << "--with-xslroot=#{Formula["docbook-xsl"].opt_prefix}/docbook-xsl"
      system "./autogen.sh", *args
      system "make", "dist"
    else
      system "./configure", *args
    end

    system "make"
    system "make", "check"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdlib.h>
      #include <jemalloc/jemalloc.h>

      int main(void) {

        for (size_t i = 0; i < 1000; i++) {
            // Leak some memory
            malloc(i * 100);
        }

        // Dump allocator statistics to stderr
        malloc_stats_print(NULL, NULL, NULL);
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-ljemalloc", "-o", "test"
    system "./test"
  end
end
