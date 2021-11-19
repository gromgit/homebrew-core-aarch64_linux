class Luau < Formula
  desc "Fast, safe, gradually typed embeddable scripting language derived from Lua"
  homepage "https://luau-lang.org"
  url "https://github.com/Roblox/luau/archive/0.505.tar.gz"
  sha256 "6399d1d3edc130e23813f6c36e29e8d563d18b00022849e3558248300dacc3ee"
  license "MIT"
  head "https://github.com/Roblox/luau.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e86d9937c9a02f3b6c5861c110e7f0c820dff6ac6a55177a88dae35f4bd8b5ad"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "94eed4db5cf95cd89902bc8e1f1fefa8f035c7fbbca8cf1c4f07110b3c78b6b8"
    sha256 cellar: :any_skip_relocation, monterey:       "0fb6130ea6223a61f5b6cc16beb93cba13d9270b8cfebace4ff58492bb645f30"
    sha256 cellar: :any_skip_relocation, big_sur:        "c6bbf46f9b4004103b5e24d4d3425bff37e23b4201c7bfc4818cad475b213867"
    sha256 cellar: :any_skip_relocation, catalina:       "3f886319d63106aac52bc0fc045d3d5cf93cb00b679516ac3a46856e367b4d3d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eee7c4093a59872dcad1d74ea3d63012b53f6480cf74581c6dd5af892df10aba"
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
