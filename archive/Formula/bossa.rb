class Bossa < Formula
  desc "Flash utility for Atmel SAM microcontrollers"
  homepage "https://github.com/shumatech/BOSSA"
  url "https://github.com/shumatech/BOSSA/archive/refs/tags/1.9.1.tar.gz"
  sha256 "ca650455dfa36cbd029010167347525bea424717a71a691381c0811591c93e72"
  license "BSD-3-Clause"
  head "https://github.com/shumatech/BOSSA.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/bossa"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "16e7d56b49f1e53adea2d2808c16a67e488482d3cb8bf503e13dd1b5985a376d"
  end

  on_linux do
    depends_on "readline"
  end

  def install
    system "make", "bin/bossac", "bin/bossash"
    bin.install "bin/bossac"
    bin.install "bin/bossash"
  end

  test do
    expected_output = /^No device found.*/
    assert_match expected_output, shell_output("#{bin}/bossac -i 2>&1", 1)
  end
end
