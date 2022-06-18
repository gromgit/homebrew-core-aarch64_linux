class Reg < Formula
  desc "Docker registry v2 command-line client"
  homepage "https://r.j3ss.co"
  url "https://github.com/genuinetools/reg/archive/v0.16.1.tar.gz"
  sha256 "b65787bff71bff21f21adc933799e70aa9b868d19b1e64f8fd24ebdc19058430"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/reg"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "3abe8029cd53be4cc65f90196c1e9d9152e3946975414d95e5d98deef56a156c"
  end

  # Bump to 1.18 on the next release, if possible.
  depends_on "go@1.17" => :build

  def install
    system "go", "build", *std_go_args
  end

  test do
    assert_match "buster", shell_output("#{bin}/reg tags debian")
  end
end
