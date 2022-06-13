class Yamdi < Formula
  desc "Add metadata to Flash video"
  homepage "https://yamdi.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/yamdi/yamdi/1.9/yamdi-1.9.tar.gz"
  sha256 "4a6630f27f6c22bcd95982bf3357747d19f40bd98297a569e9c77468b756f715"
  license "BSD-3-Clause"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/yamdi"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "67e588470614bb4b72023d2d5f64a9bfb8fdc6ee7c245bcfd2420930b798169b"
  end

  def install
    system ENV.cc, "yamdi.c", "-o", "yamdi", *ENV.cflags.to_s.split
    bin.install "yamdi"
    man1.install "man1/yamdi.1"
  end
end
