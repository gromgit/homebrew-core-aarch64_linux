class RandomizeLines < Formula
  desc "Reads and randomize lines from a file (or STDIN)"
  homepage "https://arthurdejong.org/rl/"
  url "https://arthurdejong.org/rl/rl-0.2.7.tar.gz"
  sha256 "1cfca23d6a14acd190c5a6261923757d20cb94861c9b2066991ec7a7cae33bc8"
  license "GPL-2.0"

  livecheck do
    url :homepage
    regex(/href=.*?rl[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/randomize-lines"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "a77cde566f52a0ea80ef1f8c921bbf8039a258bdf54bb34ab447ae84dcfa8974"
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.txt").write <<~EOS
      1
      2
      4
    EOS
    system "#{bin}/rl", "-c", "1", testpath/"test.txt"
  end
end
