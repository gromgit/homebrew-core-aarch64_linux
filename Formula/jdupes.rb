class Jdupes < Formula
  desc "Duplicate file finder and an enhanced fork of 'fdupes'"
  homepage "https://github.com/jbruchon/jdupes"
  url "https://github.com/jbruchon/jdupes/archive/v1.20.2.tar.gz"
  sha256 "d079d22dc77e1d181abcb8a59216520633a8712d197d007a9a9fb64c72610824"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/jdupes"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "592538e1910f7e06acb067a0cac045a1cfcde20245ca653d9ecb008425e48e52"
  end

  def install
    system "make", "install", "PREFIX=#{prefix}", "ENABLE_DEDUPE=1"
  end

  test do
    touch "a"
    touch "b"
    (testpath/"c").write("unique file")
    dupes = shell_output("#{bin}/jdupes --zeromatch .").strip.split("\n").sort
    assert_equal ["./a", "./b"], dupes
  end
end
