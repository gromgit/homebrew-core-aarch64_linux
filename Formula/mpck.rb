class Mpck < Formula
  desc "Check MP3 files for errors"
  homepage "https://checkmate.gissen.nl/"
  url "https://checkmate.gissen.nl/checkmate-0.21.tar.gz"
  sha256 "a27b4843ec06b069a46363836efda3e56e1daaf193a73a4da875e77f0945dd7a"
  license "GPL-2.0"

  livecheck do
    url "https://checkmate.gissen.nl/download.php"
    regex(/href=.*?checkmate[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/mpck"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "50443b8bfd9d794dc3a2c2095df28022bab9411079705ff20c55b77d35bedf64"
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/mpck", test_fixtures("test.mp3")
  end
end
