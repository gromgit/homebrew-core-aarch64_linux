class GitDelta < Formula
  desc "Syntax-highlighting pager for git and diff output"
  homepage "https://github.com/dandavison/delta"
  url "https://github.com/dandavison/delta/archive/0.4.3.tar.gz"
  sha256 "78ee36ec30194fe261ccb585111b67adae5166e79170f9636e54cbf5427da54a"
  license "MIT"
  head "https://github.com/dandavison/delta.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "d963089b08030f60e813d1d42ba505ee0874a40050d8ca9fc0dd3e1772b464cf" => :catalina
    sha256 "c09ae0331cccd3007eb3b0420efbd78008a252b19048ea359c76a524c5207a3a" => :mojave
    sha256 "9e3514f8c1203ab8119c3a670ada98b08f30139c2308e920cdb131c26e7e66fb" => :high_sierra
  end

  depends_on "rust" => :build
  uses_from_macos "llvm"

  conflicts_with "delta", because: "both install a `delta` binary"

  def install
    ENV.append_to_cflags "-fno-stack-check" if DevelopmentTools.clang_build_version >= 1010
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "delta #{version}", `#{bin}/delta --version`.chomp
  end
end
