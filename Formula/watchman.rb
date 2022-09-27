class Watchman < Formula
  desc "Watch files and take action when they change"
  homepage "https://github.com/facebook/watchman"
  license "MIT"

  stable do
    url "https://github.com/facebook/watchman/archive/v2022.09.26.00.tar.gz"
    sha256 "cc7c5f5a7d74383e1e360c373b3a1b973b95851366168392c297ce440e108fd5"

    resource "edencommon" do
      url "https://github.com/facebookexperimental/edencommon/archive/refs/tags/v2022.09.26.00.tar.gz"
      sha256 "1fc2724a346f27f01007a9e4f695460437788903d326ebbb52f874c98e7052b5"
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "3d524da6446df2623108f15b8c43d9174caca26aebbb5e2d5f7bedfcb44be127"
    sha256 cellar: :any,                 arm64_big_sur:  "7cfc62f869299718bf93e63b93ce281a9806ffd918012b82404bd8ca06d6b236"
    sha256 cellar: :any,                 monterey:       "65463772d45d3a1ffd65df20468fb419f478bdfe3c567ee25c8a4a4396ebe6a7"
    sha256 cellar: :any,                 big_sur:        "56f759daf13e8d5374b04b54c09622d6ab69dc5e804492e2562a12b9a1b0edb8"
    sha256 cellar: :any,                 catalina:       "68cbec2534e4069b4babf748540d78bd2709ae6939136a37bb491a98740b210e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4bdb8e6290313f93d07de738ef96b088ff8f80f5850fc93186ab1ef40429262a"
  end

  # https://github.com/facebook/watchman/issues/963
  pour_bottle? only_if: :default_prefix

  head do
    url "https://github.com/facebook/watchman.git", branch: "main"

    resource "edencommon" do
      url "https://github.com/facebookexperimental/edencommon.git", branch: "main"
    end
  end

  depends_on "cmake" => :build
  depends_on "cpptoml" => :build
  depends_on "googletest" => :build
  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "boost"
  depends_on "fb303"
  depends_on "fmt"
  depends_on "folly"
  depends_on "gflags"
  depends_on "glog"
  depends_on "libevent"
  depends_on "openssl@1.1"
  depends_on "pcre2"
  depends_on "python@3.10"

  fails_with gcc: "5"

  def install
    resource("edencommon").stage do
      system "cmake", "-S", ".", "-B", "_build",
                      *std_cmake_args(install_prefix: buildpath/"edencommon")
      system "cmake", "--build", "_build"
      system "cmake", "--install", "_build"
    end

    # Fix build failure on Linux. Borrowed from Fedora:
    # https://src.fedoraproject.org/rpms/watchman/blob/rawhide/f/watchman.spec#_70
    inreplace "CMakeLists.txt", /^t_test/, "#t_test" if OS.linux?

    # NOTE: Setting `BUILD_SHARED_LIBS=ON` will generate DSOs for Eden libraries.
    #       These libraries are not part of any install targets and have the wrong
    #       RPATHs configured, so will need to be installed and relocated manually
    #       if they are built as shared libraries. They're not used by any other
    #       formulae, so let's link them statically instead. This is done by default.
    system "cmake", "-S", ".", "-B", "build",
                    "-Dedencommon_DIR=#{buildpath}/edencommon/lib/cmake/edencommon",
                    "-DENABLE_EDEN_SUPPORT=ON",
                    "-DWATCHMAN_VERSION_OVERRIDE=#{version}",
                    "-DWATCHMAN_BUILDINFO_OVERRIDE=#{tap.user}",
                    "-DWATCHMAN_STATE_DIR=#{var}/run/watchman",
                    *std_cmake_args

    # Workaround for `Process terminated due to timeout`
    ENV.deparallelize { system "cmake", "--build", "build" }
    system "cmake", "--install", "build"

    path = Pathname.new(File.join(prefix, HOMEBREW_PREFIX))
    bin.install (path/"bin").children
    lib.install (path/"lib").children
    path.rmtree
  end

  def post_install
    (var/"run/watchman").mkpath
    chmod 042777, var/"run/watchman"
  end

  test do
    assert_equal(version.to_s, shell_output("#{bin}/watchman -v").chomp)
  end
end
