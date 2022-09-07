class TtySolitaire < Formula
  desc "Ncurses-based klondike solitaire game"
  homepage "https://github.com/mpereira/tty-solitaire"
  url "https://github.com/mpereira/tty-solitaire/archive/v1.3.1.tar.gz"
  sha256 "f2b80c8d5317e67db43c1dbf3b0f5f3dfea5e826c18744562615f1b1536ae433"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/tty-solitaire"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "84d80a39f7b4be799e8fa24e7a34dc02a24995538c35e01faa71d237d48d1416"
  end

  uses_from_macos "ncurses"

  def install
    system "make"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system "#{bin}/ttysolitaire", "-h"
  end
end
