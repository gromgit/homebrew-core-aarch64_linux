class Luau < Formula
  desc "Fast, safe, gradually typed embeddable scripting language derived from Lua"
  homepage "https://luau-lang.org"
  url "https://github.com/Roblox/luau/archive/0.542.tar.gz"
  sha256 "cac9bfbdc1490ea69171b211ac0ebf8c63fcb24c3cff8482922c67d95b01d5e1"
  license "MIT"
  head "https://github.com/Roblox/luau.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b558db2914dcd16d85860e608249250fc4eae41899079bfd257ad3f942aa6aca"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7e3948d540bebd7d2c62e07e168d577e3c455629d3905d908749dcb7d33bfc41"
    sha256 cellar: :any_skip_relocation, monterey:       "02c982cd47d0f53e497d3539f6cec260ffcc95c18085672363120929697bb27b"
    sha256 cellar: :any_skip_relocation, big_sur:        "91708b74dd2dc854948f86ba61fe73b2cd6307355c1a9709a94c8ca92db3dc71"
    sha256 cellar: :any_skip_relocation, catalina:       "ca69fefbcd8b40e3e3b2e07dd249c54d24d7289846c9d251fee9e840e9d33cbd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "80cf945b0f0b2232e4b162b07ae98ba4c6c153f91e605a0aad8ff0cb73739dc4"
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
