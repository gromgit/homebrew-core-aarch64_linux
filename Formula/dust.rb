class Dust < Formula
  desc "More intuitive version of du in rust"
  homepage "https://github.com/bootandy/dust"
  url "https://github.com/bootandy/dust/archive/v0.5.2.tar.gz"
  sha256 "15f0d3578eb54e15fc502237c1d7f9cea62037f1b62b5a8d99641f12690d4a95"
  license "Apache-2.0"
  head "https://github.com/bootandy/dust.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "2d26a2fa524049d8b2a32b3076f7de243c7929c943b5c0190d8cc5c9a2ba41d3" => :catalina
    sha256 "3e92fcb18d37bd8dde1d8e52a44c8f96a5086a7afb5ced6895262af0b3e8395b" => :mojave
    sha256 "ffa147a323f5ff57cbea0eb8817acdfff88c1f349f5f1f35d0bf3dc64e6c8faf" => :high_sierra
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match /\d+.+?\./, shell_output("#{bin}/dust -n 1")
  end
end
