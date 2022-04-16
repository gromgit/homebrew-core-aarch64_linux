class Xgboost < Formula
  desc "Scalable, Portable and Distributed Gradient Boosting Library"
  homepage "https://xgboost.ai/"
  url "https://github.com/dmlc/xgboost.git",
      tag:      "v1.6.0",
      revision: "f75c007f27ae2a3b0f8b4db7930a2179431ea55f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "13de9936f61bf73fb626131adacfbe6e81de5aa8dfb1f8474520460e73a3caf1"
    sha256 cellar: :any,                 arm64_big_sur:  "560109c6182da4022278f7f2f6f574bbc2396c492c4090d120b41359535160a0"
    sha256 cellar: :any,                 monterey:       "a70ff0e77c3e4c2e189b347e704a5b1d9b16563e1059ee7bc8c48d9f9af9eceb"
    sha256 cellar: :any,                 big_sur:        "6bbeac3b7dab98469c61412efdd933aa7baf09b3e467985641f590f66d71e063"
    sha256 cellar: :any,                 catalina:       "d4e1ae7fbf7ece4221a7c6cc0bc31c2b35200ab16c6f66e00a74c0536c027ada"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "08b4ea482b2ee5af89b0b218d50f3b3a51264c137b88a2578d6a8d46b9d83b39"
  end

  depends_on "cmake" => :build
  depends_on "numpy"
  depends_on "scipy"

  on_macos do
    depends_on "libomp"
    depends_on "llvm" => :build if DevelopmentTools.clang_build_version <= 1100
  end

  on_linux do
    depends_on "gcc"
  end

  fails_with :clang do
    build 1100
    cause <<-EOS
      clang: error: unable to execute command: Segmentation fault: 11
      clang: error: clang frontend command failed due to signal (use -v to see invocation)
      make[2]: *** [src/CMakeFiles/objxgboost.dir/tree/updater_quantile_hist.cc.o] Error 254
    EOS
  end

  # Starting in XGBoost 1.6.0, compiling with GCC 5.4.0 results in:
  # src/linear/coordinate_common.h:414:35: internal compiler error: in tsubst_copy, at cp/pt.c:13039
  # This compiler bug is fixed in more recent versions of GCC: https://gcc.gnu.org/bugzilla/show_bug.cgi?id=80543
  # Upstream issue filed at https://github.com/dmlc/xgboost/issues/7820
  fails_with gcc: "5"

  def install
    ENV.remove "HOMEBREW_LIBRARY_PATHS", Formula["llvm"].opt_lib
    ENV.llvm_clang if OS.mac? && (DevelopmentTools.clang_build_version <= 1100)

    mkdir "build" do
      system "cmake", *std_cmake_args, ".."
      system "make"
      system "make", "install"
    end
    pkgshare.install "demo"
  end

  test do
    # Force use of Clang on Mojave
    ENV.clang if OS.mac?

    cp_r (pkgshare/"demo"), testpath
    cd "demo/data" do
      cp "../CLI/binary_classification/mushroom.conf", "."
      system "#{bin}/xgboost", "mushroom.conf"
    end
  end
end
