class Demumble < Formula
  desc "More powerful symbol demangler (a la c++filt)"
  homepage "https://github.com/nico/demumble"
  url "https://github.com/nico/demumble/archive/refs/tags/v1.2.2.tar.gz"
  sha256 "663e5d205c83cc36a257bb168d3ecbc2a49693088c0451b2405d25646651c63e"
  license "Apache-2.0"
  head "https://github.com/nico/demumble.git", branch: "main"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/demumble"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "bbf2853082c3fa3336482d0adb07ade633e0559d39afabdbfcdfc30c5327c35e"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"

    # CMakeLists.txt does not contain install rules
    bin.install "build/demumble"
  end

  test do
    mangled = "__imp_?FLAGS_logtostderr@fLB@@3_NA"
    demangled = "__imp_bool fLB::FLAGS_logtostderr"
    assert_equal demangled, pipe_output(bin/"demumble", mangled)
  end
end
