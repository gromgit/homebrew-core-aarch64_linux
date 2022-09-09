class Luau < Formula
  desc "Fast, safe, gradually typed embeddable scripting language derived from Lua"
  homepage "https://luau-lang.org"
  url "https://github.com/Roblox/luau/archive/0.544.tar.gz"
  sha256 "c1e2d4e04fe6f191192d1570bd83f96531804fc484a0bc0e00b53248a01d7dee"
  license "MIT"
  head "https://github.com/Roblox/luau.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3d03abd3a8e2c393e21f323c4b5076d7dddc76b10aa35940501cf2a4d31b3190"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "604648145cf7cc9fa7b82fa2833681a4a25738694e7f73a7c9595e026016345f"
    sha256 cellar: :any_skip_relocation, monterey:       "7369055a5abc90d0be6d20501bc3408e9ef9236508ab46c96497d17638f170af"
    sha256 cellar: :any_skip_relocation, big_sur:        "51dbe1cde63b8573c9bc262233458e1cd22e357beaa051e798371d098db8f848"
    sha256 cellar: :any_skip_relocation, catalina:       "0a0efc0432b92ba125b059ec5a21ec9cb9df5cb2d2b928d2591c758591c4e117"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "96fd8398742cc8287f7c2dc333f12aad9c6800ced4743875670e027732a37daa"
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
