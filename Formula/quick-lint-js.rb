class QuickLintJs < Formula
  desc "Find bugs in your JavaScript code"
  homepage "https://quick-lint-js.com/"
  url "https://c.quick-lint-js.com/releases/2.4.2/source/quick-lint-js-2.4.2.tar.gz"
  sha256 "c52f961669439ae13e9676d471118f995baf46279da70ac0a7c98c4aede925fd"
  license "GPL-3.0-or-later"
  revision 3
  head "https://github.com/quick-lint/quick-lint-js.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "4dacaf1dc182adec0119abe7f79b79b487cdde06a6e229f701b9a44a2fa51ac0"
    sha256 cellar: :any,                 arm64_big_sur:  "6226a6d07a1b067a63e4b90f38760afc6db0c236ddfcaa69f61db20db3ac4138"
    sha256 cellar: :any,                 monterey:       "d578c0d01b5f427b8cde637bd74433f1454dc8f86466b85420945864e8da84d1"
    sha256 cellar: :any,                 big_sur:        "c0622d112c2b3e8c8618b6e66a7e3ced6860e214bf99e82e589eab15fd9f97e4"
    sha256 cellar: :any,                 catalina:       "15b061762d5772d4dcccbe9d3ad93a3cc72d5a80bcce9f5c14e5161c1927fa78"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f9b6cf175fae161800718395525a39959ffe21b2ad0cae3fb73a62ca7f0eb163"
  end

  depends_on "cmake" => :build
  depends_on "googletest" => :build
  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "simdjson"

  on_linux do
    # Use Homebrew's C++ compiler in case the host's C++
    # compiler is too old.
    depends_on "gcc"
  end

  # quick-lint-js requires some C++17 features, thus
  # requires GCC 8 or newer.
  fails_with gcc: "5"
  fails_with gcc: "6"
  fails_with gcc: "7"

  def install
    system "cmake", "-S", ".", "-B", "build",
                    "-DBUILD_TESTING=ON",
                    "-DQUICK_LINT_JS_ENABLE_BENCHMARKS=OFF",
                    "-DQUICK_LINT_JS_INSTALL_EMACS_DIR=#{elisp}",
                    "-DQUICK_LINT_JS_INSTALL_VIM_NEOVIM_TAGS=ON",
                    "-DQUICK_LINT_JS_USE_BUNDLED_BOOST=OFF",
                    "-DQUICK_LINT_JS_USE_BUNDLED_GOOGLE_BENCHMARK=OFF",
                    "-DQUICK_LINT_JS_USE_BUNDLED_GOOGLE_TEST=OFF",
                    "-DQUICK_LINT_JS_USE_BUNDLED_SIMDJSON=OFF",
                    *std_cmake_args
    system "cmake", "--build", "build"
    chdir "build" do
      system "ctest", "-V"
    end
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"errors.js").write <<~EOF
      const x = 3;
      const x = 4;
    EOF
    ohai "#{bin}/quick-lint-js errors.js"
    output = `#{bin}/quick-lint-js errors.js 2>&1`
    puts output
    refute_equal $CHILD_STATUS.exitstatus, 0
    assert_match "E0034", output

    (testpath/"no-errors.js").write 'console.log("hello, world!");'
    assert_empty shell_output("#{bin}/quick-lint-js no-errors.js")
  end
end
