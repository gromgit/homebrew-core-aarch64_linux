class Luau < Formula
  desc "Fast, safe, gradually typed embeddable scripting language derived from Lua"
  homepage "https://luau-lang.org"
  url "https://github.com/Roblox/luau/archive/0.526.tar.gz"
  sha256 "64b39fd654db44f66eed8be235d33ee94d624d5d847bba8fa69a2003a6977712"
  license "MIT"
  head "https://github.com/Roblox/luau.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cababb8d39da89d00ee66c77515c7f25eb13df05dcae1142b9dc513742116120"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b4d69f620833007f7f481d3b3a17d324538e8540ef6a03c0650afe1f2fccb2c7"
    sha256 cellar: :any_skip_relocation, monterey:       "6da19aae373141df5519fd993676907572bd60e5c7014a022c8d12c66112d878"
    sha256 cellar: :any_skip_relocation, big_sur:        "e8c5f695f5d1166b5b2ca7512e9aeb76e716aaa30dc57bf5d97529a54c07e8f5"
    sha256 cellar: :any_skip_relocation, catalina:       "4b710275769ff3b67e4baa4c2d8bb2e1bfd1e741d54d3b1a15c7d397ad039f1e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bbc083216a32d5c8483326c9fc2be589483cfd6a4aba52b4cf0de91dc33590f4"
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
