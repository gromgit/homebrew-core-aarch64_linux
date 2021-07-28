class Trunk < Formula
  desc "Build, bundle & ship your Rust WASM application to the web"
  homepage "https://github.com/thedodd/trunk"
  url "https://github.com/thedodd/trunk/archive/v0.12.1.tar.gz"
  sha256 "6f4e74f83f1ab7a224f1ab82483cde90be7057e6b6f6f26754e8aff8f3e1ba98"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/thedodd/trunk.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "35a2a5d15c734e550e3c19f992317f7bd56eefe010a578a9064cdf0b2b9fc422"
    sha256 cellar: :any_skip_relocation, big_sur:       "ad02044660a3f1f9ee3ad972c650022107ae982c46cef836c0c27d22b44494e6"
    sha256 cellar: :any_skip_relocation, catalina:      "7066418172fcc946a5ccdf6ab3c1ffbf74939efa38c41e4448c81903c286f44a"
    sha256 cellar: :any_skip_relocation, mojave:        "fa07e6fa4721154019890ed0545be12d49adef5c3c4d57410fb49d2c04cb3582"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b1eb0bef5e59651f1fcd2625e02ff63e7a996faa8d488539aeb6866c97045454"
  end

  depends_on "rust" => :build

  uses_from_macos "openssl@1.1"
  uses_from_macos "zlib"

  on_linux do
    depends_on "pkg-config" => :build
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "ConfigOpts {\n", shell_output("#{bin}/trunk config show")
  end
end
