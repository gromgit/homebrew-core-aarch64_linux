class Cobalt < Formula
  desc "Static site generator written in Rust"
  homepage "https://cobalt-org.github.io/"
  url "https://github.com/cobalt-org/cobalt.rs/archive/v0.15.10.tar.gz"
  sha256 "8c767705ad6fc1b1a0824d16c8722b6ae8f12fe1e297e457665192c7403bf27a"

  bottle do
    cellar :any_skip_relocation
    sha256 "b4d5964e7f563fc9830649c7c48c2ea39fea6f6dfac5570849bc387b80f7cddb" => :catalina
    sha256 "5ec652252f103a47994608db385e88d7a007efc4c1f8e139615a90e3b1b11e13" => :mojave
    sha256 "8a37fe5e663008ceb952af4ff682bc1faa941fbf3e66632ed8bf7bf0402c9f2b" => :high_sierra
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--locked", "--root", prefix, "--path", "."
  end

  test do
    system bin/"cobalt", "init"
    system bin/"cobalt", "build"
    assert_predicate testpath/"_site/index.html", :exist?
  end
end
