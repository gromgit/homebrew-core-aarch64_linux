class Regldg < Formula
  desc "Regular expression grammar language dictionary generator"
  homepage "https://regldg.com/"
  url "https://regldg.com/regldg-1.0.1.tar.gz"
  sha256 "f5f401c645a94d4c737cefa2bbcb62f23407d25868327902b9c93b501335dc99"
  license "MIT"

  livecheck do
    url "https://regldg.com/download.html"
    regex(/href=.*?regldg[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/regldg"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "d8c7480c3878eda0b3ec7ebd0d48f1067a86a3e31e5ae519fa63c1a00c291ffb"
  end

  def install
    # Temporary Homebrew-specific work around for linker flag ordering problem in Ubuntu 16.04.
    # Remove after migration to 18.04.
    inreplace "Makefile", "-o regldg", "-o regldg -lm" unless OS.mac?
    system "make"
    bin.install "regldg"
  end

  test do
    system "#{bin}/regldg", "test"
  end
end
