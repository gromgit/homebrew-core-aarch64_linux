class Cobalt < Formula
  desc "Static site generator written in Rust"
  homepage "https://cobalt-org.github.io/"
  url "https://github.com/cobalt-org/cobalt.rs/archive/v0.15.9.tar.gz"
  sha256 "aa4b943cebb1ae67b3f30c3103b03f4feb40085d7225b417059fea686cd4063c"

  bottle do
    cellar :any_skip_relocation
    sha256 "070ad779bd8276698d37dad60cc8fb2ceb0b9118151731d62570f8ea3c2ae9f8" => :catalina
    sha256 "c1c86bd9c06b8745ccd63f552fb2c7ff3ba9a620fe222b18eefceb1f53da32d3" => :mojave
    sha256 "d5584a225dc664e46a0043c88d2885327787b270ea498177eac88752c2850319" => :high_sierra
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
