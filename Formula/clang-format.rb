class ClangFormat < Formula
  desc "Formatting tools for C, C++, Obj-C, Java, JavaScript, TypeScript"
  homepage "https://clang.llvm.org/docs/ClangFormat.html"
  # The LLVM Project is under the Apache License v2.0 with LLVM Exceptions
  license "Apache-2.0"
  version_scheme 1
  head "https://github.com/llvm/llvm-project.git"

  stable do
    url "https://github.com/llvm/llvm-project/releases/download/llvmorg-11.0.1/llvm-11.0.1.src.tar.xz"
    sha256 "ccd87c254b6aebc5077e4e6977d08d4be888e7eb672c6630a26a15d58b59b528"

    resource "clang" do
      url "https://github.com/llvm/llvm-project/releases/download/llvmorg-11.0.1/clang-11.0.1.src.tar.xz"
      sha256 "73f572c2eefc5a155e01bcd84815751d722a4d3925f53c144acfb93eeb274b4d"
    end

    resource "libcxx" do
      url "https://github.com/llvm/llvm-project/releases/download/llvmorg-11.0.1/libcxx-11.0.1.src.tar.xz"
      sha256 "9fd5f669621ffea88a2b93e3d99f3a958b5defb954f71bf754709b63275f5e3d"
    end

    resource "libcxxabi" do
      url "https://github.com/llvm/llvm-project/releases/download/llvmorg-11.0.1/libcxxabi-11.0.1.src.tar.xz"
      sha256 "4a697056a5c08621a8380dcaf3836525835aa76b3008d9e8f27abf9270bf683f"
    end
  end

  livecheck do
    url :stable
    strategy :github_latest
    regex(%r{href=.*?/tag/llvmorg[._-]v?(\d+(?:\.\d+)+)}i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "7978ffd41bd627e9054073763e8fca8a90f282636127bd17719d1b8326885a5e" => :big_sur
    sha256 "9b299661bc571c3d711d0203f9b3de3f50b36f744f339ad3261d35ddc5f15db0" => :arm64_big_sur
    sha256 "679f98a5595d37a20e018471c3b12ca2bf18ba4e26fe5311caafc24c627b8d9b" => :catalina
    sha256 "70bbea9c85e84c730b36bd4ea27c0b219fe902d2a5ef8f9415c33b1653114e3e" => :mojave
  end

  depends_on "cmake" => :build
  depends_on "ninja" => :build

  uses_from_macos "libxml2"
  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  def install
    if build.head?
      ln_s buildpath/"libcxx", buildpath/"llvm/projects/libcxx"
      ln_s buildpath/"libcxxabi", buildpath/"llvm/tools/libcxxabi"
      ln_s buildpath/"clang", buildpath/"llvm/tools/clang"
    else
      (buildpath/"projects/libcxx").install resource("libcxx")
      (buildpath/"projects/libcxxabi").install resource("libcxxabi")
      (buildpath/"tools/clang").install resource("clang")
    end

    llvmpath = build.head? ? buildpath/"llvm" : buildpath

    mkdir llvmpath/"build" do
      args = std_cmake_args
      args << "-DLLVM_ENABLE_LIBCXX=ON"
      args << "-DLLVM_EXTERNAL_PROJECTS=\"clang;libcxx;libcxxabi\""
      args << "-DLLVM_EXTERNAL_LIBCXX_SOURCE_DIR=\"#{buildpath/"projects/libcxx"}\""
      args << "-DCMAKE_BUILD_TYPE=Release"
      args << ".."
      system "cmake", "-G", "Ninja", *args
      system "ninja", "clang-format"
    end

    bin.install llvmpath/"build/bin/clang-format"
    bin.install llvmpath/"tools/clang/tools/clang-format/git-clang-format"
    (share/"clang").install Dir[llvmpath/"tools/clang/tools/clang-format/clang-format*"]
  end

  test do
    # NB: below C code is messily formatted on purpose.
    (testpath/"test.c").write <<~EOS
      int         main(char *args) { \n   \t printf("hello"); }
    EOS

    assert_equal "int main(char *args) { printf(\"hello\"); }\n",
        shell_output("#{bin}/clang-format -style=Google test.c")
  end
end
