class Bedtools < Formula
  desc "Tools for genome arithmetic (set theory on the genome)"
  homepage "https://github.com/arq5x/bedtools2"
  url "https://github.com/arq5x/bedtools2/archive/v2.30.0.tar.gz"
  sha256 "c575861ec746322961cd15d8c0b532bb2a19333f1cf167bbff73230a7d67302f"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/bedtools"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "1c039e6a9ea115f23111b9d12841a460d8457702b78429c0dee560bfc47b32b9"
  end


  depends_on "python@3.10" => :build
  depends_on "xz"

  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  def install
    inreplace "Makefile", "python", "python3"

    system "make"
    system "make", "install", "prefix=#{prefix}"
  end

  test do
    (testpath/"t.bed").write "c\t1\t5\nc\t4\t9"
    assert_equal "c\t1\t9", shell_output("#{bin}/bedtools merge -i t.bed").chomp
  end
end
