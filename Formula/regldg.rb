class Regldg < Formula
  desc "Regular expression grammar language dictionary generator"
  homepage "https://regldg.com/"
  url "https://regldg.com/regldg-1.0.0.tar.gz"
  sha256 "cd550592cc7a2f29f5882dcd9cf892875dd4e84840d8fe87133df9814c8003f1"

  livecheck do
    url "https://regldg.com/download.php"
    regex(/href=.*?regldg[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/regldg"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "9b113b771386ff850c244865d885251e8c937737cf315617d1be13892e6f0c80"
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
