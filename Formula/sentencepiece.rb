class Sentencepiece < Formula
  desc "Unsupervised text tokenizer and detokenizer"
  homepage "https://github.com/google/sentencepiece"
  url "https://github.com/google/sentencepiece/archive/v0.1.90.tar.gz"
  sha256 "e87b491d1d9e58657d3856e521e37ebff4f03e5501047c709db125d0375c7e83"

  bottle do
    sha256 "a76efbe9aa72abd0a119faf3b3694e77102284b22ec567a2d18472ec52d7c402" => :catalina
    sha256 "f7244e947ec84c223e441c07482e8805cc9e590ce6f2dc93a4c1c5049c7a4a4f" => :mojave
    sha256 "78bb55baa1320006ffe370dba1c6c90b08aa567ae20627b409627d179c128e38" => :high_sierra
  end

  depends_on "cmake" => :build

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make"
      system "make", "install"
    end
    pkgshare.install "data"
  end

  test do
    cp (pkgshare/"data/botchan.txt"), testpath
    system "#{bin}/spm_train", "--input=botchan.txt", "--model_prefix=m", "--vocab_size=1000"
  end
end
