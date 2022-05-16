class Luau < Formula
  desc "Fast, safe, gradually typed embeddable scripting language derived from Lua"
  homepage "https://luau-lang.org"
  url "https://github.com/Roblox/luau/archive/0.527.tar.gz"
  sha256 "aeba1a886cffd9394815ceb6c0bf5e4cede6ba1be1fa5623a61747a8edb6dd5b"
  license "MIT"
  head "https://github.com/Roblox/luau.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2dc8efd8e436df1ea9ed2e8bda8a590146a864238b28e0ebcbb507dbb3fdd570"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "90ab4ae0f5b645ebd408bbe06ac8d04bd137f755d02db78e59c09fde09109127"
    sha256 cellar: :any_skip_relocation, monterey:       "01d06261c948b9eb54b29dc597937b149ec54db21cd74148fb3b0bdaafc91f36"
    sha256 cellar: :any_skip_relocation, big_sur:        "684a411eb64228b1e8ecec98154bcbaa98584a1f7c2249358596a4c4e6e49963"
    sha256 cellar: :any_skip_relocation, catalina:       "dbc14cff1c3526148420b18a1a03fa0467bc4e40b3a9b26341089d16e16c11d7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "db51169b8789e473ade0431ff8afcd963f68cbee136eb3adb40d0c05ac657e9b"
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
