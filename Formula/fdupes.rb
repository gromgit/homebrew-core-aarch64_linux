class Fdupes < Formula
  desc "Identify or delete duplicate files"
  homepage "https://github.com/adrianlopezroche/fdupes"
  url "https://github.com/adrianlopezroche/fdupes/releases/download/v2.1.2/fdupes-2.1.2.tar.gz"
  sha256 "cd5cb53b6d898cf20f19b57b81114a5b263cc1149cd0da3104578b083b2837bd"
  license "MIT"
  version_scheme 1

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/fdupes"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "77a1aef7fd831045faa46186e53df5e0fbfbecc7c6dcb3b3289ffda4c58fb03d"
  end

  depends_on "pcre2"

  uses_from_macos "ncurses"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    touch "a"
    touch "b"

    dupes = shell_output("#{bin}/fdupes .").strip.split("\n").sort
    assert_equal ["./a", "./b"], dupes
  end
end
