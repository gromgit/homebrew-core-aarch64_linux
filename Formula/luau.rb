class Luau < Formula
  desc "Fast, safe, gradually typed embeddable scripting language derived from Lua"
  homepage "https://luau-lang.org"
  url "https://github.com/Roblox/luau/archive/0.526.tar.gz"
  sha256 "64b39fd654db44f66eed8be235d33ee94d624d5d847bba8fa69a2003a6977712"
  license "MIT"
  head "https://github.com/Roblox/luau.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a89d0f7d9f410d2cb9b088d54fa3cba2271329398a08b81ffa45b8cf2d265f1f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c18d270097c78cef46acb074db3f16a3ce4c15d0e60ff78be9ad25f9fa2b866d"
    sha256 cellar: :any_skip_relocation, monterey:       "55c1978d606bc10ff3dacaac56c03fd41e5adf1b57ffc95683a7c48071f47bc3"
    sha256 cellar: :any_skip_relocation, big_sur:        "e64c3c45a11bb6612c849baaa62227503391f0e25ef2821bf6745df52167ba72"
    sha256 cellar: :any_skip_relocation, catalina:       "5ef8da9c25369191bea2c41d077bf90a24c9f698ec159bdc718488ac94d4eda2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4f13197767670c0ed6d29648bbf88de04ed75d20bb7ff35b8065251c3f3aaaa6"
  end

  depends_on "cmake" => :build

  on_linux do
    depends_on "gcc"
  end

  fails_with gcc: "5"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args, "-DLUAU_BUILD_TESTS=OFF"
    system "cmake", "--build", "build"
    bin.install "build/luau", "build/luau-analyze"
  end

  test do
    (testpath/"test.lua").write "print ('Homebrew is awesome!')\n"
    assert_match "Homebrew is awesome!", shell_output("#{bin}/luau test.lua")
  end
end
