class Cobalt < Formula
  desc "Static site generator written in Rust"
  homepage "https://cobalt-org.github.io/"
  url "https://github.com/cobalt-org/cobalt.rs/archive/v0.15.8.tar.gz"
  sha256 "241f4b8b8cd0fb832d46d964e7fcfdd5933d342c3d8c78fdd2e6174bd323a0a4"

  bottle do
    cellar :any_skip_relocation
    sha256 "7da5547aa1e225bbe60cf4cf74d155f5ddc621965cbc78335427b9e01ca48b49" => :catalina
    sha256 "d3d5f3ba5437490ada57c5b18a7205b554df5fbfa6a9f9d40c71eb8412a5dd78" => :mojave
    sha256 "d620530bc9fa5040165fc8d50ba9b2240ba2275d9f394f8fcace27f22f151b0a" => :high_sierra
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
