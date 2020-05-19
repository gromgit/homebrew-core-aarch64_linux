class Sentencepiece < Formula
  desc "Unsupervised text tokenizer and detokenizer"
  homepage "https://github.com/google/sentencepiece"
  url "https://github.com/google/sentencepiece/archive/v0.1.90.tar.gz"
  sha256 "e87b491d1d9e58657d3856e521e37ebff4f03e5501047c709db125d0375c7e83"

  bottle do
    sha256 "8b4bc405045212b612d915a96aad81c05a6f916d6769a2bc2c952238ff78dc98" => :catalina
    sha256 "d6d03e58c3c958dd718bc93868d2b7e94872f2f32019fd49d9647ec0b5f4ee64" => :mojave
    sha256 "2d602907dd89dc64704f646985dbea6e1c878a695bfb27245fc3d6fe29db5a50" => :high_sierra
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
