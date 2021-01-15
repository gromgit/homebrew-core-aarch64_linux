class Mdbook < Formula
  desc "Create modern online books from Markdown files"
  homepage "https://rust-lang.github.io/mdBook/"
  url "https://github.com/rust-lang/mdBook/archive/v0.4.6.tar.gz"
  sha256 "a0a8f8e65030370cec8f5114ccb57334c9f2b7153dc51677e12dc74632d3ed23"
  license "MPL-2.0"
  head "https://github.com/rust-lang/mdBook.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "8c7f9275b61725f5a0fd55dfa0f2b6bcee1f32c97ce0a3edddb794991c182f60" => :big_sur
    sha256 "6c898809def13270a09f20cf42c59c368292493fb80dafaeb44e3ffd3da3ad2d" => :arm64_big_sur
    sha256 "aa2d7ccc4217a17265f0f80c7108274007d62ee7f75d93039a36bef0dabf2af4" => :catalina
    sha256 "8055c1481f4857452eb98bded515dc393610c82d985f86b6b995a40e2ed3b8f5" => :mojave
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # simulate user input to mdbook init
    system "sh", "-c", "printf \\n\\n | #{bin}/mdbook init"
    system "#{bin}/mdbook", "build"
  end
end
