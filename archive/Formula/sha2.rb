class Sha2 < Formula
  desc "Implementation of SHA-256, SHA-384, and SHA-512 hash algorithms"
  homepage "https://aarongifford.com/computers/sha.html"
  url "https://aarongifford.com/computers/sha2-1.0.1.tgz"
  sha256 "67bc662955c6ca2fa6a0ce372c4794ec3d0cd2c1e50b124e7a75af7e23dd1d0c"

  livecheck do
    url :homepage
    regex(/href=.*?sha2[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/sha2"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "0129b7f3cf68fa0ee7b5334a432929fcbb1f401205474e065693065100b5bfe1"
  end

  def install
    # Xcode 12 made -Wimplicit-function-declaration an error by default so we need to
    # disable that warning to successfully compile:
    system ENV.cc, "-o", "sha2", "-Wno-implicit-function-declaration", "sha2prog.c", "sha2.c"
    system "perl", "sha2test.pl"
    bin.install "sha2"
  end

  test do
    (testpath/"checkme.txt").write "homebrew"
    output = "12c87370d1b5472793e67682596b60efe2c6038d63d04134a1a88544509737b4"
    assert_match output, pipe_output("#{bin}/sha2 -q -256 #{testpath}/checkme.txt")
  end
end
