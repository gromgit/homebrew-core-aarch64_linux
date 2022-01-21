class Luau < Formula
  desc "Fast, safe, gradually typed embeddable scripting language derived from Lua"
  homepage "https://luau-lang.org"
  url "https://github.com/Roblox/luau/archive/0.511.tar.gz"
  sha256 "ce032f690303b75d3264522ee59de39502849d1dd44a9161d2f3a23239e563ff"
  license "MIT"
  head "https://github.com/Roblox/luau.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "eedf7db42a1a09b865365f47209ff8bf16b12e517ae7313b7905d88a5b0cf006"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2161592db768292580c91e44e8d3addc5efecd683c47c592b4d6bc3144512eed"
    sha256 cellar: :any_skip_relocation, monterey:       "337c72956901c48edc2655a68fabbfe57623aabecb3de8386bffb1a657750ed9"
    sha256 cellar: :any_skip_relocation, big_sur:        "621519a67b7bd3d670e68818b3ad3a948aa0d96ff55f8760257b7cde6f2a0adc"
    sha256 cellar: :any_skip_relocation, catalina:       "80f55b2ec890aa24a446fb0c668a9aef8d1023a52bc143fb5d039f271db30e98"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4d39f3a01a7814cd48d8a24c796055b22f9539299fa3e716115896fd6b3373ec"
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
