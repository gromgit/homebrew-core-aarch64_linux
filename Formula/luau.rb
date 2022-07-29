class Luau < Formula
  desc "Fast, safe, gradually typed embeddable scripting language derived from Lua"
  homepage "https://luau-lang.org"
  url "https://github.com/Roblox/luau/archive/0.538.tar.gz"
  sha256 "8a1240e02a7daacf1e5cff249040a3298c013157fc496c66adce6dcb21cc30be"
  license "MIT"
  head "https://github.com/Roblox/luau.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e09386a45a7f916cfacdbed73d5c36f9d13016c83419abd43f67721c3dd65fea"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "96150f7457327df4c22136302e68bbc692cb06b114d11ee749f94e3cea7290a4"
    sha256 cellar: :any_skip_relocation, monterey:       "90e0976abbdde804216ad4695f18b300a2a95060e707d34caeb603a75f80f350"
    sha256 cellar: :any_skip_relocation, big_sur:        "92029deea570759ae174fbe2fc68259895c4f938549e4cbb971f5834ef7949b4"
    sha256 cellar: :any_skip_relocation, catalina:       "78d708071e8d701a1adb763ca071de37ca86d3bb9be79943eed12c300be0215d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4bd4324fb230db3b0c90da5a64235125204e4b5f6353711c0b5e0854ee91ac62"
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
