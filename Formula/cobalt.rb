class Cobalt < Formula
  desc "Static site generator written in Rust"
  homepage "https://cobalt-org.github.io/"
  url "https://github.com/cobalt-org/cobalt.rs/archive/v0.16.2.tar.gz"
  sha256 "0410a48a9ad276b1fab82b9a3b0548f896cc0c403d3e5c62480e3a74c79bfbef"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "c5086533f291688d0729939f84720d98564d0fe03abd930ce93b514ec3c7c121" => :catalina
    sha256 "504eb4b6f09a6f24bcaca95fbaae57d40dc2d3cbb8570a4ae9b244d6bd946ffb" => :mojave
    sha256 "ae8924b5bf3fa835ba0fd93a823f30a6f4b7f5657a59aafe27e05c6e1a30d18c" => :high_sierra
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system bin/"cobalt", "init"
    system bin/"cobalt", "build"
    assert_predicate testpath/"_site/index.html", :exist?
  end
end
