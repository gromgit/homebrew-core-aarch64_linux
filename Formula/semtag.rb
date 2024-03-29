class Semtag < Formula
  desc "Semantic tagging script for git"
  homepage "https://github.com/nico2sh/semtag"
  url "https://github.com/nico2sh/semtag/archive/v0.1.1.tar.gz"
  sha256 "c7becf71c7c14cdef26d3980c3116cce8dad6cd9eb61abcc4d2ff04e2c0f8645"
  license "Apache-2.0"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/semtag"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "6a6b37e1523c6ebf66395fc503680c0a069b09d2d97607aee0025591c8e4c8a8"
  end

  def install
    bin.install "semtag"
  end

  test do
    touch "file.txt"
    system "git", "init"
    system "git", "add", "file.txt"
    system "git", "commit", "-m'test'"
    system bin/"semtag", "final"
    output = shell_output("git tag --list")
    assert_match "v0.0.1", output
  end
end
