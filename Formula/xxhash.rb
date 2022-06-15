class Xxhash < Formula
  desc "Extremely fast non-cryptographic hash algorithm"
  homepage "https://github.com/Cyan4973/xxHash"
  url "https://github.com/Cyan4973/xxHash/archive/v0.8.1.tar.gz"
  sha256 "3bb6b7d6f30c591dd65aaaff1c8b7a5b94d81687998ca9400082c739a690436c"
  license "BSD-2-Clause"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/xxhash"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "c4be461f27a4f6cef331c733ba364e91cd5f4b42852b77f2db540c7030b34ae1"
  end

  def install
    system "make"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    (testpath/"leaflet.txt").write "No computer should be without one!"
    assert_match(/^67bc7cc242ebc50a/, shell_output("#{bin}/xxhsum leaflet.txt"))
  end
end
