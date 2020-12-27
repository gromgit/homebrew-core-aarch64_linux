class CargoWatch < Formula
  desc "Watches over your Cargo project's source"
  homepage "https://github.com/passcod/cargo-watch"
  url "https://github.com/passcod/cargo-watch/archive/v7.5.0.tar.gz"
  sha256 "0d26b2c714f8e02ae4c7a1c4f87496e979694ab7847d3b74959c0d15c92f70ef"
  license "CC0-1.0"
  head "https://github.com/passcod/cargo-watch.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "07d9a040ecf1f8fa64404f3fe54d1fee1942e947c1840a35630eacae1589d844" => :big_sur
    sha256 "60215fc98f1860979b64335e42e77720c9eecdc0c915e134118d3e6b3cb40703" => :catalina
    sha256 "581b7f6d973525e0565179a7aa2cf0127ae2af70882159d602046ac910e30eed" => :mojave
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    output = shell_output("#{bin}/cargo-watch -x build 2>&1", 1)
    assert_match "error: Not a Cargo project, aborting.", output

    assert_equal "cargo-watch #{version}", shell_output("#{bin}/cargo-watch --version").strip
  end
end
