class Tokei < Formula
  desc "Program that allows you to count code, quickly"
  homepage "https://github.com/XAMPPRocky/tokei"
  url "https://github.com/XAMPPRocky/tokei/archive/v12.1.0.tar.gz"
  sha256 "cd86db17fa7e1d94c9de905f8c3afca92b21c6448a2fc4359e270cb8daad0be2"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "a5a4a2aefab52cea3c0abd10b80772635966012a1ddd84a874ee90e6ff12449c" => :big_sur
    sha256 "02597fe551d45f767d7cd56feea1fd525db6906010a74578f18aee31d11c9c8f" => :catalina
    sha256 "e9caee7fc7bb14601ae148e4e79c7c00c0348d46f1c663aac542f06d48a97e96" => :mojave
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--features", "all", *std_cargo_args
  end

  test do
    (testpath/"lib.rs").write <<~EOS
      #[cfg(test)]
      mod tests {
          #[test]
          fn test() {
              println!("It works!");
          }
      }
    EOS
    system bin/"tokei", "lib.rs"
  end
end
