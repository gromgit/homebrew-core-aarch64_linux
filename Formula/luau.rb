class Luau < Formula
  desc "Fast, safe, gradually typed embeddable scripting language derived from Lua"
  homepage "https://luau-lang.org"
  url "https://github.com/Roblox/luau/archive/0.535.tar.gz"
  sha256 "2acb39fb00b4836226033a3ef17665c71e30e6bd62550941710d66e286ff7a9e"
  license "MIT"
  head "https://github.com/Roblox/luau.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "922ca8eb5214b0e11e2c979b5acf20404623e297ab729d03ce050d331358a0db"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "21d99c34ea6280da228a2e57463cc045d0b0495a33cbf64b277e3439401271e2"
    sha256 cellar: :any_skip_relocation, monterey:       "be7a9a581742978aeccbe8347a22671633b82dd9aba6405ae7225af58e4e954d"
    sha256 cellar: :any_skip_relocation, big_sur:        "e85fb8fdd674e8f69872e5de76be43905c50510e2201ab77c5e85c214b1bcc66"
    sha256 cellar: :any_skip_relocation, catalina:       "cf7f3b8737ff21edaf42214f8bcc6eb652a7868691bda5795d5924eb9e934eeb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "84ef2c31dbaeccfd2b9cb0918f55a13f4eeae58844177a32b64ab2011b632de5"
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
