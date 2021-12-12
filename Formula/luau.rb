class Luau < Formula
  desc "Fast, safe, gradually typed embeddable scripting language derived from Lua"
  homepage "https://luau-lang.org"
  url "https://github.com/Roblox/luau/archive/0.507.tar.gz"
  sha256 "cd9220246f2d5512d80e17f9899b6a890d239f21c863885bac673d615e63f85f"
  license "MIT"
  head "https://github.com/Roblox/luau.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6a9785cad4d4cf69a3147cb31d691ebbcd2c6cd7eae1c230fe3b671de802f3b0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "89ae2a5e3c7531d02d58e7823d943b42479cc030dab9c7c431c38e3985f5e329"
    sha256 cellar: :any_skip_relocation, monterey:       "98ec35c16b87f8c4950f66f518571d094e00dbb4e6313713e69f0fa32f5cf1cf"
    sha256 cellar: :any_skip_relocation, big_sur:        "c9017b21070e3343fecc579162056c1788ccfab517bbb82edf92a06bc2cc992f"
    sha256 cellar: :any_skip_relocation, catalina:       "316fc171bcd92689971bfd2b349e0fa66aed7752bf804f4ad84fccdd91742d42"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2997dd1517af84e576005f6501bb5a7131739cd9e6c252d827b3b6eb0e4071cb"
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
