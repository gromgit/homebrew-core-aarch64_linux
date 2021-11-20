class Luau < Formula
  desc "Fast, safe, gradually typed embeddable scripting language derived from Lua"
  homepage "https://luau-lang.org"
  url "https://github.com/Roblox/luau/archive/0.505.tar.gz"
  sha256 "6399d1d3edc130e23813f6c36e29e8d563d18b00022849e3558248300dacc3ee"
  license "MIT"
  head "https://github.com/Roblox/luau.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ff98f81bd0a8a3ea73dc2bec65042c57063af2132e498b9e31eb28b86606fa39"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d0122af53c772f3bc5ad5ab0f73d980e8e77325c315d940d4088331a28ce43a0"
    sha256 cellar: :any_skip_relocation, monterey:       "0a4a539ef2549eb5b6c920cb870114aa25db5b389aedc86c195871326e742c70"
    sha256 cellar: :any_skip_relocation, big_sur:        "2a3ab7da8991ab66f4b6f4f4cb95c003b1e4135de8d734d1dc26a0814c8dfa15"
    sha256 cellar: :any_skip_relocation, catalina:       "f942044565d37e55f86ba19b5a229cd0c4d8834dc504714ffbe00b3a1b319e76"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8c410fc2d8f59ea7267e70f0529f284ca067feaacd4001750492185ec0cb9c5a"
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
