class Oak < Formula
  desc "Expressive, simple, dynamic programming language"
  homepage "https://oaklang.org/"
  url "https://github.com/thesephist/oak/archive/v0.2.tar.gz"
  sha256 "d06ba53f88490f5d8f70f45515afaf6ee8e4119c8ab477e3b4de8ef3cc7a2c05"
  license "MIT"
  head "https://github.com/thesephist/oak.git", branch: "main"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/oak"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "173824ce05709fbc423f6765dc197114b063b0b19397ca563dfac8fa6e649da8"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_equal "Hello, World!\n14\n", shell_output("oak eval \"std.println('Hello, World!')\"")
  end
end
