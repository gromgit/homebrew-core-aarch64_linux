class Ccls < Formula
  desc "C/C++/ObjC language server"
  homepage "https://github.com/MaskRay/ccls"
  # NOTE: Upstream often does not mark the latest release on GitHub, so
  #       this can be updated with the new tag.
  #       https://github.com/Homebrew/homebrew-core/pull/106939
  #       https://github.com/MaskRay/ccls/issues/786
  #       https://github.com/MaskRay/ccls/issues/895
  url "https://github.com/MaskRay/ccls/archive/0.20220729.tar.gz"
  sha256 "af19be36597c2a38b526ce7138c72a64c7fb63827830c4cff92256151fc7a6f4"
  license "Apache-2.0"
  revision 4
  head "https://github.com/MaskRay/ccls.git", branch: "master"

  bottle do
    sha256                               arm64_monterey: "c97192b61b1debf20be0af09c5f21d22dee2a5e16f90b7929637801ce4522107"
    sha256                               arm64_big_sur:  "706844c727ae94dd6300b29473ada957f48e51d40ed355241a5260f7f7c4bf67"
    sha256                               monterey:       "eba018141192f4f0509d4dc3ff13eb7302d17483631e1d1a4e804546b7ae8327"
    sha256                               big_sur:        "60d85d2a1f95d760aaf05fca18ad571b1eea78e431ca765d24e3353b06a4f453"
    sha256                               catalina:       "0f56677edf23670a26f1a522f5f3c7734e00857b44ed7bc3cad03d5590b468ec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a1c5cbc08231f833f479651546cfc8573048945ada8584c56b976bda4707f53d"
  end

  depends_on "cmake" => :build
  depends_on "rapidjson" => :build
  depends_on "llvm"
  depends_on macos: :high_sierra # C++ 17 is required

  fails_with gcc: "5"

  def llvm
    deps.reject { |d| d.build? || d.test? }
        .map(&:to_formula)
        .find { |f| f.name.match?(/^llvm(@\d+)?$/) }
  end

  def install
    resource_dir = Utils.safe_popen_read(llvm.opt_bin/"clang", "-print-resource-dir").chomp
    resource_dir.gsub! llvm.prefix.realpath, llvm.opt_prefix
    system "cmake", "-S", ".", "-B", "build", "-DCLANG_RESOURCE_DIR=#{resource_dir}", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    output = shell_output("#{bin}/ccls -index=#{testpath} 2>&1")

    resource_dir = output.match(/resource-dir=(\S+)/)[1]
    assert_path_exists "#{resource_dir}/include"
  end
end
