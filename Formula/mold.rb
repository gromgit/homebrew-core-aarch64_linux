class Mold < Formula
  desc "Modern Linker"
  homepage "https://github.com/rui314/mold"
  url "https://github.com/rui314/mold/archive/v1.6.0.tar.gz"
  sha256 "59cd3ea1a2a5fb50d0d97faddd8bff4c7e71054a576c00a87b17f56ecbd88729"
  license "AGPL-3.0-only"
  head "https://github.com/rui314/mold.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_monterey: "bce5c72fa042b0278d29fecc350d98b3176a40161b1199ae55087b434c6644ab"
    sha256 cellar: :any,                 arm64_big_sur:  "7f4fa0847248cff08996a670c192cee6a0a2f8429bb98f231fadee623d388097"
    sha256 cellar: :any,                 monterey:       "f9015bf8a2c84adc6f55f4fe4776942f7613ad98b8da5cc69180aaab9bc434fb"
    sha256 cellar: :any,                 big_sur:        "d334e5e62d7f3e49f0c1bd71f31a66b55cf866557f03f88c2f7ac84f69bd6d21"
    sha256 cellar: :any,                 catalina:       "759f5405e9d9d794869ab9333407623abaef89d8dbbfb664e87958da6fef8beb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d1ae1f16437be40c840b8675ee02d2c84c17457a0c50680e2f4bb219ee94b418"
  end

  depends_on "cmake" => :build
  depends_on "tbb"
  depends_on "zstd"
  uses_from_macos "zlib"

  on_macos do
    depends_on "llvm" => :build if DevelopmentTools.clang_build_version <= 1200
  end

  on_linux do
    depends_on "mimalloc"
    depends_on "openssl@1.1" # Uses CommonCrypto on macOS
  end

  fails_with :clang do
    build 1200
    cause "Requires C++20"
  end

  fails_with :gcc do
    version "7"
    cause "Requires C++20"
  end

  def install
    ENV.llvm_clang if OS.mac? && (DevelopmentTools.clang_build_version <= 1200)

    # Undefine the `LIBDIR` macro to avoid embedding it in the binary.
    # This helps make the bottle relocatable.
    ENV.append_to_cflags "-ULIBDIR"
    # Ensure we're using Homebrew-provided versions of these dependencies.
    %w[mimalloc tbb zlib zstd].map { |dir| (buildpath/"third-party"/dir).rmtree }
    args = %w[
      -DMOLD_LTO=ON
      -DMOLD_USE_MIMALLOC=ON
      -DMOLD_USE_SYSTEM_MIMALLOC=ON
      -DMOLD_USE_SYSTEM_TBB=ON
      -DCMAKE_SKIP_INSTALL_RULES=OFF
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    inreplace buildpath.glob("test/macho/*.sh"), "./ld64", bin/"ld64.mold", false
    inreplace buildpath.glob("test/elf/*.sh") do |s|
      s.gsub!(%r{(`pwd`/)?mold-wrapper}, lib/"mold/mold-wrapper", false)
      s.gsub!(%r{(\.|`pwd`)/mold}, bin/"mold", false)
      s.gsub!(/-B[^\s]+/, "-B#{libexec}/mold", false)
    end
    pkgshare.install "test"
  end

  test do
    (testpath/"test.c").write <<~EOS
      int main(void) { return 0; }
    EOS

    linker_flag = case ENV.compiler
    when /^gcc(-(\d|10|11))?$/ then "-B#{libexec}/mold"
    when :clang, /^gcc-\d{2,}$/ then "-fuse-ld=mold"
    else odie "unexpected compiler"
    end

    system ENV.cc, linker_flag, "test.c"
    system "./a.out"
    # Tests use `--ld-path`, which is not supported on old versions of Apple Clang.
    return if OS.mac? && MacOS.version < :big_sur

    if OS.mac?
      cp_r pkgshare/"test", testpath
      # Delete failing test. Reported upstream at
      # https://github.com/rui314/mold/issues/735
      if (MacOS.version == :monterey) && Hardware::CPU.arm?
        untested = %w[libunwind objc-selector]
        testpath.glob("test/macho/{#{untested.join(",")}}.sh").map(&:unlink)
      end
      testpath.glob("test/macho/*.sh").each { |t| system t }
    else
      system bin/"mold", "-run", ENV.cc, "test.c", "-o", "test"
      system "./test"
    end
  end
end
