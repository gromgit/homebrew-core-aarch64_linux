class Luau < Formula
  desc "Fast, safe, gradually typed embeddable scripting language derived from Lua"
  homepage "https://luau-lang.org"
  url "https://github.com/Roblox/luau/archive/0.546.tar.gz"
  sha256 "fcc07da039a040187aba54a6a221fd553d261836c47a0845d03f8b7f7da5e58a"
  license "MIT"
  head "https://github.com/Roblox/luau.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "86f114858498e8c9c8691f4c6e3c9326623f70aaa9eb74cad5127d2cd0ec9a30"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a8d45ae32ccb8d85ac26408a8b7701ab29820b0401f95ef378b0e8fd60949141"
    sha256 cellar: :any_skip_relocation, monterey:       "ceecf2f601e8cf201237daed6695390c9cbb558052d4ba2657c5af04cdb806b4"
    sha256 cellar: :any_skip_relocation, big_sur:        "15b7547be3c1e149e9de54e756bb4eb2ff9975c69540f9ef16aeda44209da231"
    sha256 cellar: :any_skip_relocation, catalina:       "6d3699f5772d1ee0c5fa609e0166eb56466274bf16deed06e682409b59c05dc6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "396571add92df7402245ae4d7d4559c1e8c878568b6d26e29d9e48ac6a00b138"
  end

  depends_on "cmake" => :build

  fails_with gcc: "5"

  def install
    system "cmake", "-S", ".", "-B", "build", "-DLUAU_BUILD_TESTS=OFF", *std_cmake_args
    system "cmake", "--build", "build"
    bin.install "build/luau", "build/luau-analyze"
  end

  test do
    (testpath/"test.lua").write "print ('Homebrew is awesome!')\n"
    assert_match "Homebrew is awesome!", shell_output("#{bin}/luau test.lua")
  end
end
