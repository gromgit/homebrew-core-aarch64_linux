class Sickle < Formula
  desc "Windowed adaptive trimming for FASTQ files using quality"
  homepage "https://github.com/najoshi/sickle"
  url "https://github.com/najoshi/sickle/archive/v1.33.tar.gz"
  sha256 "eab271d25dc799e2ce67c25626128f8f8ed65e3cd68e799479bba20964624734"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/sickle"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "173fda571aa6ffcfa545b6967b35a951f2558480c834d8d28020ae1b1db30ab3"
  end

  uses_from_macos "zlib"

  def install
    system "make"
    bin.install "sickle"
  end

  test do
    (testpath/"test.fastq").write <<~EOS
      @U00096.2:1-70
      AGCTTTTCATTCTGACTGCAACGGGCAATATGTCTCTGTGTGGATTAAAAAAAGAGTGTCTGATAGCAGC
      +
      IIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII0000000000
    EOS
    cmd = "#{bin}/sickle se -f test.fastq -t sanger -o /dev/stdout"
    assert_equal "GTGTC\n", shell_output(cmd).lines[1][-6..]
  end
end
