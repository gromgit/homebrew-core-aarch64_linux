class Mold < Formula
  desc "Modern Linker"
  homepage "https://github.com/rui314/mold"
  url "https://github.com/rui314/mold/archive/v1.0.1.tar.gz"
  sha256 "b0d54602d1229c26583ee8a0132e53463c4d755f9dbc456475f388fd8a1aa3e4"
  license "AGPL-3.0-only"
  head "https://github.com/rui314/mold.git", branch: "main"

  bottle do
    sha256 arm64_monterey: "f3762565b2b74ee55c28d80b121b9bb0c9ed940fd45dde37c08d0f686bfc4481"
    sha256 arm64_big_sur:  "9e86a84670f20f9ff3ba1c074a045a9f2aa8e2be9caf1381c1644e77c78c4eca"
    sha256 monterey:       "9b275f3950aaa2411bdddd51687d402fc21226599d6a7dafb6d6091c338fb270"
    sha256 big_sur:        "8507515e39bbd20ee428ebb1457a94fb28498cfe9c94908fd06ea32a96a8d199"
    sha256 catalina:       "5e9c985f9b13dc6fb081e01105617cbaf02dce84be59b835a477b67a89be0dfe"
    sha256 x86_64_linux:   "5dbf095b179aa148a1193c59e2ddd07659cc3d0498ade0ca446bd3b62e513807"
  end

  depends_on "tbb"
  depends_on "xxhash"
  uses_from_macos "zlib"

  on_macos do
    # mold can only link ELF executables (for now)
    # https://github.com/rui314/mold/issues/189
    depends_on "x86_64-elf-gcc" => :test
    depends_on "llvm" => [:build, :test] if DevelopmentTools.clang_build_version <= 1200
  end

  on_linux do
    depends_on "gcc"
    depends_on "mimalloc"
    depends_on "openssl@1.1" # Uses CommonCrypto on macOS
  end

  fails_with :clang do
    build 1200
    cause "Requires C++20"
  end

  # Requires C++20
  fails_with gcc: "5"
  fails_with gcc: "6"
  fails_with gcc: "7"

  def install
    ENV.remove "HOMEBREW_LIBRARY_PATHS", Formula["llvm"].opt_lib
    ENV.llvm_clang if OS.mac? && (DevelopmentTools.clang_build_version <= 1200)

    args = %W[
      PREFIX=#{prefix}
      LTO=1
      SYSTEM_MIMALLOC=1
      SYSTEM_TBB=1
      SYSTEM_XXHASH=1
    ]
    args << "STRIP=true" if OS.mac?
    system "make", *args, "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      int main(void) { return 0; }
    EOS

    ENV["CC"] = "x86_64-elf-gcc" if OS.mac?

    system ENV.cc, "-c", "test.c"
    system bin/"mold", "test.o"
    assert_predicate testpath/"a.out", :exist?
    return if OS.mac?

    system bin/"mold", "-run", ENV.cc, "test.c", "-o", "test"
    system "./test"
  end
end
