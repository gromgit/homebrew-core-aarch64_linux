class Cobalt < Formula
  desc "Static site generator written in Rust"
  homepage "https://cobalt-org.github.io/"
  url "https://github.com/cobalt-org/cobalt.rs/archive/v0.16.4.tar.gz"
  sha256 "24b1fde3bdd1c8e6e8aa0e24c37c1bd2821a7e41a8bce4724f0473fd3722c478"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "05ca26b8e2ae6c7f10f6e52ad37027d8d3990092a37e78d3a2475bdda2fa51f7" => :catalina
    sha256 "52b2a35136119708ec6598dbf8b964ca5cdc71bd955a04bbeda4a9dc45741e71" => :mojave
    sha256 "5001ab4d12aed7498b3bd42cad67cc75c6e8aecdb6fcde205b0a7c989ce260eb" => :high_sierra
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
