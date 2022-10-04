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
  revision 3
  head "https://github.com/MaskRay/ccls.git", branch: "master"

  bottle do
    sha256                               arm64_monterey: "ee93a0287f9c6e8145050a57b3994af40c67dfaa7f7e56a8a4e985a618396019"
    sha256                               arm64_big_sur:  "11539e7113f9c1b042de078aa952ff9fa771eb032227fc03c84d80f1af667e85"
    sha256                               monterey:       "e72d3b81f7aca23e003b29e8f50d041346cb9b43da1e710c68dfabf5cc63f1e6"
    sha256                               big_sur:        "01955d7bde370f690b3d103791d2b0406befecaf07be30875221059c66c0d6a3"
    sha256                               catalina:       "3f29a7f25c9f7a64bf4706866c1a85c5bfad94a16eca77f817564c06ba22245c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "33545fca050e5d942cff1c06c3a61304ce05ba5760c9a508b197dd3f66c5e7de"
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
