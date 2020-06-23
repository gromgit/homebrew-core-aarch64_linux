class Mafft < Formula
  desc "Multiple alignments with fast Fourier transforms"
  homepage "https://mafft.cbrc.jp/alignment/software/"
  url "https://mafft.cbrc.jp/alignment/software/mafft-7.470-with-extensions-src.tgz"
  sha256 "7d7e6c58a1060e061feec507a3dcba567be94e7d335ab87499134abc3731b00f"

  bottle do
    cellar :any_skip_relocation
    sha256 "f05192f8000a9df20fd61456ce59be5747570fc6535f8c7d018e4395c5b0f214" => :catalina
    sha256 "dcde3c89f1c54b002a9fb80946a79801b7e0082ec0c4891b3967479dc606ebee" => :mojave
    sha256 "dda2aa7a240491e453fb98318389ed9a193775a6e74845f56698eb16eced9159" => :high_sierra
  end

  def install
    make_args = %W[CC=#{ENV.cc} CXX=#{ENV.cxx} PREFIX=#{prefix} install]
    system "make", "-C", "core", *make_args
    system "make", "-C", "extensions", *make_args
  end

  test do
    (testpath/"test.fa").write ">1\nA\n>2\nA"
    output = shell_output("#{bin}/mafft test.fa")
    assert_match ">1\na\n>2\na", output
  end
end
