class Minised < Formula
  desc "Smaller, cheaper, faster SED implementation"
  homepage "https://www.exactcode.com/opensource/minised/"
  url "https://dl.exactcode.de/oss/minised/minised-1.16.tar.gz"
  sha256 "46e072d5d45c9fd3d5b268523501bbea0ad016232b2d3f366a7aad0b1e7b3f71"
  license "BSD-3-Clause"

  livecheck do
    url :homepage
    regex(/href=.*?minised[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/minised"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "5832bd32efdf301e47b2586edd026715c7a2d9bef449299b6f319c08537e7a4b"
  end

  def install
    system "make"
    system "make", "DESTDIR=#{prefix}", "PREFIX=", "install"
  end

  test do
    output = pipe_output("#{bin}/minised 's:o::'", "hello world", 0)
    assert_equal "hell world", output.chomp
  end
end
