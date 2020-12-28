class GitDelta < Formula
  desc "Syntax-highlighting pager for git and diff output"
  homepage "https://github.com/dandavison/delta"
  url "https://github.com/dandavison/delta/archive/0.4.5.tar.gz"
  sha256 "e19ab2d6a7977a3aa939a2d70b6d007aad8b494a901d47a3e0c2357eedad0c80"
  license "MIT"
  revision 1
  head "https://github.com/dandavison/delta.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "aee0af5a8de8eb12ba91831a9f76ca3303285505539aa6e8c80671ab1f705281" => :big_sur
    sha256 "a9d1db1320dde94de82bb5697c9d155a9c76b6da2ec448265aebdeb1d9b7ae60" => :catalina
    sha256 "266585a17107f7fb7fe6942cb2abb7dd4f5bc8c0ef582fc50e63a51501d33852" => :mojave
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
