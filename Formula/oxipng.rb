class Oxipng < Formula
  desc "Multithreaded PNG optimizer written in Rust"
  homepage "https://github.com/shssoichiro/oxipng"
  url "https://github.com/shssoichiro/oxipng/archive/v4.0.0.tar.gz"
  sha256 "10308fb78bc5b1b00b7450d812f652bfe6fb6d98d68a0c540bb5d3b9cfd56e68"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "731dc0bb62382fcc1ed327a9991af54c8b9e5a3744390eb0f33a820a2d76fba5" => :catalina
    sha256 "e7a6e4f1073c53479339da86dc958fd1cf7337892f7a6ff471437d9a03f9d4d2" => :mojave
    sha256 "78c733696edd12b4c76459399d792d0723bf469d1add45449b26d19877843be9" => :high_sierra
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system "#{bin}/oxipng", "--pretend", test_fixtures("test.png")
  end
end
