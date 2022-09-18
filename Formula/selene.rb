class Selene < Formula
  desc "Blazing-fast modern Lua linter"
  homepage "https://kampfkarren.github.io/selene"
  url "https://github.com/Kampfkarren/selene/archive/0.21.0.tar.gz"
  sha256 "2c3639b8a461232f06e6b7c8c7a7d2bd312df72a474aa66076561cfb6bbaa069"
  license "MPL-2.0"
  head "https://github.com/Kampfkarren/selene.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "54040c47bfe3bea2e48ce2b0fddd0ed3f70598d28a94e5e7725689cc745fdf7b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "47fc0bf33032d556f5cca4b2e8cc5673ef3b177474b5e855e942e23626924e03"
    sha256 cellar: :any_skip_relocation, monterey:       "45ca78e09185af543c09ecef61aae2a00784497f32999f29b3fcdf762baef6e5"
    sha256 cellar: :any_skip_relocation, big_sur:        "81f20004a994af5c74d2b06271dcd4b57421727076af2d1fbbd76e0698e40f58"
    sha256 cellar: :any_skip_relocation, catalina:       "051bbee945f273b325df60fe650c6fc6b35eaeb8e6f9350f787b4c9a25256c2d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b545c8c9d667584d258fedf46fcb38409f248018265ed38d7395ecfb5c4103fb"
  end

  depends_on "rust" => :build
  depends_on "openssl@1.1"

  on_linux do
    depends_on "pkg-config" => :build
  end

  def install
    cd "selene" do
      system "cargo", "install", "--bin", "selene", *std_cargo_args
    end
  end

  test do
    (testpath/"selene.toml").write("std = \"lua52\"")
    (testpath/"test.lua").write("print(1 / 0)")
    assert_match "warning[divide_by_zero]", shell_output("#{bin}/selene #{testpath}/test.lua", 1)
  end
end
