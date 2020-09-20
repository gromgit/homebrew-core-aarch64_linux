class Janet < Formula
  desc "Dynamic language and bytecode vm"
  homepage "https://janet-lang.org"
  url "https://github.com/janet-lang/janet/archive/v1.12.2.tar.gz"
  sha256 "1cdbc4e944fb429a80bb415b657fc955579a4d7b1206fed9b32b9c60b20e477c"
  license "MIT"
  head "https://github.com/janet-lang/janet.git"

  bottle do
    cellar :any
    sha256 "7efb5eeeb8d8171d4710aae573b85b7824206d98b2638bb9610990d30129cab2" => :catalina
    sha256 "17875a8b4e4f3d815e7ebb009176ec759882650d04f69bc01a0042ceaa52bb66" => :mojave
    sha256 "0213b576cc87a46a9e936ec144c26d9f1187d166a291c49808a6c371cc63090d" => :high_sierra
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build

  def install
    system "meson", "setup", "build", *std_meson_args
    cd "build" do
      system "ninja"
      system "ninja", "install"
    end
  end

  test do
    assert_equal "12", shell_output("#{bin}/janet -e '(print (+ 5 7))'").strip
  end
end
