class Fdupes < Formula
  desc "Identify or delete duplicate files"
  homepage "https://github.com/adrianlopezroche/fdupes"
  url "https://github.com/adrianlopezroche/fdupes/releases/download/v2.2.0/fdupes-2.2.0.tar.gz"
  sha256 "174e488c21c3d0475228fe95c268c7f518d92f2732bdf36d1964dc285538e1ac"
  license "MIT"
  version_scheme 1

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/fdupes"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "bd9696fd01c4788a7230bd8df733a925f07ede5fe9a86cd5123b9a1c0e0f3c3b"
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
