class GitDelta < Formula
  desc "Syntax-highlighting pager for git and diff output"
  homepage "https://github.com/dandavison/delta"
  url "https://github.com/dandavison/delta/archive/0.5.0.tar.gz"
  sha256 "aef2ef9e4260eabb7a04f36f0485c9b041029a7da1d69d9e6eabb03a7466ab26"
  license "MIT"
  head "https://github.com/dandavison/delta.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "223b5315ca1c4977da846f8125feb3eec9ac95bb854c89c250838931294b6548" => :big_sur
    sha256 "e6ea46ea542b446bd5402a0f03d1fb824da03d71ad64d2326824a954ab0ac1c9" => :catalina
    sha256 "f6054d63ffe6a8958195901b798f50d586e216e0ad424145bd3d2d376e365be4" => :mojave
  end

  depends_on "rust" => :build
  uses_from_macos "llvm"

  conflicts_with "delta", because: "both install a `delta` binary"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "delta #{version}", `#{bin}/delta --version`.chomp
  end
end
