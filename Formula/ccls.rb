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
  revision 2
  head "https://github.com/MaskRay/ccls.git", branch: "master"

  bottle do
    sha256                               arm64_monterey: "7761300607dbe0555d4057810a65a4f7c2f40e8a89e2e4ca585660f7af7c3f63"
    sha256                               arm64_big_sur:  "56f294fe7f59eb5c066be9fcf1f1ffed5aa857e8fe238c2243c0b0cba67dc9e4"
    sha256                               monterey:       "6ebd4515c46909ca5af95f1594950fd5c96dbe6dc675ac02355b3f761f8dea7c"
    sha256                               big_sur:        "3f898bba48428ef990d2dc6d95e6237eab3b899b97d7aae02efb2dad2059199a"
    sha256                               catalina:       "e80db8885695a569a37648148df1c996835523697ed7cc7798609e589181e3d2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ff6772ae6732d5a0ddd63d46d5ed510b03d37db5df5829bd33ea90fcda299431"
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
