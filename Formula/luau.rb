class Luau < Formula
  desc "Fast, safe, gradually typed embeddable scripting language derived from Lua"
  homepage "https://luau-lang.org"
  url "https://github.com/Roblox/luau/archive/0.536.tar.gz"
  sha256 "e6de36e83e9c537d92bcc94852ab498e3c15a310fd2c4cc4e21c616d8ae1a84f"
  license "MIT"
  head "https://github.com/Roblox/luau.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e9e013455c3fdb205a7be746988b6394676afc08fcab9a5003932dc9d51f1ca6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "940659b8bd435423a7fa4c20383f390c3e137a750865838335981057dd2e35d3"
    sha256 cellar: :any_skip_relocation, monterey:       "75291a59d41936d6e70542b6223eb4ea100d71c4fc9b47601b2da7fa15aa2442"
    sha256 cellar: :any_skip_relocation, big_sur:        "9b81abaf2c19a116059435da35c3a021ef306e74e925fb6a21d9332157872dd2"
    sha256 cellar: :any_skip_relocation, catalina:       "52fc2b33a18af17fc2182e614436d8560dd1e4a2849414a63bb16212ab2cfc94"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ee3c89d9176938c252ef095cd00e0fd40b6ab625dd80a563cba31b6e7805e1e9"
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
