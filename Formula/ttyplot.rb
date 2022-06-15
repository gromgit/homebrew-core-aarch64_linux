class Ttyplot < Formula
  desc "Realtime plotting utility for terminal with data input from stdin"
  homepage "https://github.com/tenox7/ttyplot"
  url "https://github.com/tenox7/ttyplot/archive/1.4.tar.gz"
  sha256 "11974754981406d19cfa16865b59770faaf3ade8d909d9a0134dc56e00d29bd4"
  license "Apache-2.0"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/ttyplot"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "e2340b5614a9d0e90d80def8c5cce8b5e431c0d7ef45cc16659e7094b5b73782"
  end

  uses_from_macos "ncurses"

  def install
    system "make"
    bin.install "ttyplot"
  end

  test do
    system "#{bin}/ttyplot", "--help"
    # ttyplot normally reads data over time:
    # piping lines to it will just let it start and immediately exit successfully.
    system "echo 1 2 3 | #{bin}/ttyplot"
  end
end
