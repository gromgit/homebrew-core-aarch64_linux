class Luau < Formula
  desc "Fast, safe, gradually typed embeddable scripting language derived from Lua"
  homepage "https://luau-lang.org"
  url "https://github.com/Roblox/luau/archive/0.512.tar.gz"
  sha256 "9d0c6813d77c28de8a6de06991dfc3bf90d32bc0ea7157fa52afe066ace9447b"
  license "MIT"
  head "https://github.com/Roblox/luau.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d629a65413dc5e9a90164469320d322b6e0065d6e2fc0b52f599cc4b750ba4d2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "227998678852daeaf9f554d6cf80b6c77eddc82ef0ddcb2a874c8d84f68cf0ac"
    sha256 cellar: :any_skip_relocation, monterey:       "49262956cd3410ab73013c43dcb4b12097fc5bb2bc7410fdae4d78346a566358"
    sha256 cellar: :any_skip_relocation, big_sur:        "3cd4d71d6b8a2bc1229a51abcaf5a7f7a66ecac721ca1cce4a8cc49966c4b160"
    sha256 cellar: :any_skip_relocation, catalina:       "a894f7f3dc6c401d3285c1b4845bd43833491ef81bb8e2e34e4d5d8d2f8ec729"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cc41cb55c57ffb7e5b8295892e8daa4a5fae7a98a82458345b6cf2e13d7911c5"
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
