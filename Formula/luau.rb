class Luau < Formula
  desc "Fast, safe, gradually typed embeddable scripting language derived from Lua"
  homepage "https://luau-lang.org"
  url "https://github.com/Roblox/luau/archive/0.547.tar.gz"
  sha256 "61cb72c4794555aad4a02963e1eb7271a04b937872d316a02a463e044d45391b"
  license "MIT"
  head "https://github.com/Roblox/luau.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4b93059e6b8803da52eaa64e810c2442a0b0998b5a471d2e2f25e29681819089"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3fe8578bec56d84075972552aa838b76dcc1127cb935778feae15928e93f1465"
    sha256 cellar: :any_skip_relocation, monterey:       "752fe908e5058f108af819772a73ff1dc8d7e58a8616a5fb8100ed733403144c"
    sha256 cellar: :any_skip_relocation, big_sur:        "54dc96f742e9877b1ce5a7d8ba7fcafa9aa03c42d2928a4db0d8833b152c8eeb"
    sha256 cellar: :any_skip_relocation, catalina:       "3445d163ea2d87ad66b955aff293b142421bbfa4b94ef840ea1c3bebb09d1798"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1804f305a0ba6dacc673ad1b7028168e127dc30dfab747a31d26abd41968fce1"
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
