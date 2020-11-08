class Gravity < Formula
  desc "Embeddable programming language"
  homepage "https://marcobambini.github.io/gravity/"
  url "https://github.com/marcobambini/gravity/archive/0.8.0.tar.gz"
  sha256 "c2a62846110164e6e4f50ca98c3fa38269d84ac9452cb85e75a88f50cec2f53b"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "bbe0bbe4ea0aaa3b4585c232b4c4fbef8e51ab906be17fc6f76df9876594bb0c" => :catalina
    sha256 "ae65ee69f6a7b53ba1c1bdbaf9e07f421766d023158ef44cb1a6a6df1cee516f" => :mojave
    sha256 "8d1b8b51674fa30da8827f01fef3352a67e0319ebaabc0ea9cf05926280053b5" => :high_sierra
  end

  def install
    system "make"
    bin.install "gravity"
    doc.install Dir["docs/*"]
  end

  test do
    (testpath/"hello.gravity").write <<~EOS
      func main() {
          System.print("Hello World!")
      }
    EOS
    system bin/"gravity", "-c", "hello.gravity", "-o", "out.json"
    assert_equal "Hello World!\n", shell_output("#{bin}/gravity -q -x out.json")
    assert_equal "Hello World!\n", shell_output("#{bin}/gravity -q hello.gravity")
  end
end
