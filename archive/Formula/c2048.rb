class C2048 < Formula
  desc "Console version of 2048"
  homepage "https://github.com/mevdschee/2048.c"
  url "https://github.com/mevdschee/2048.c.git",
      revision: "578a5f314e1ce31b57e645a8c0a2c9d9d5539cde"
  version "0+20150805"
  license "MIT"
  head "https://github.com/mevdschee/2048.c.git", branch: "main"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/c2048"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "abf5af88d96d7ea1f0f26c67e7649b568740866194675ac1012698d4b5f5f386"
  end

  def install
    system "make"
    bin.install "2048"
  end

  def caveats
    <<~EOS
      The game supports different color schemes.
      For the black-to white:
        2048 blackwhite
      For the blue-to-red:
        2048 bluered
    EOS
  end

  test do
    system "#{bin}/2048", "test"
  end
end
