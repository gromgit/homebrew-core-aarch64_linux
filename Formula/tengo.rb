class Tengo < Formula
  desc "Fast script language for Go"
  homepage "https://tengolang.com"
  url "https://github.com/d5/tengo/archive/v2.6.1.tar.gz"
  sha256 "f27ce070a881cd9396b9430103026067f835319b4aa763e1dcfaf3a450c2b7ce"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "ff566e05a3ad3a9c701a120bdeaab1d827b88fd080b5cff2414f126f81bb9aa7" => :catalina
    sha256 "32509cb1d3000c8b81ef23aee8d45b7e9d0bd323813aec71274917e62cf1d548" => :mojave
    sha256 "937265ab2612c87d48a6277d7ef62e17395f427faaf1f5da4951a1ad12c427ea" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "./cmd/tengo"
  end

  test do
    (testpath/"main.tengo").write <<~EOS
      fmt := import("fmt")

      each := func(seq, fn) {
          for x in seq { fn(x) }
      }

      sum := func(init, seq) {
          each(seq, func(x) { init += x })
          return init
      }

      fmt.println(sum(0, [1, 2, 3]))   // "6"
      fmt.println(sum("", [1, 2, 3]))  // "123"
    EOS
    assert_equal shell_output("#{bin}/tengo #{testpath}/main.tengo"), "6\n123\n"
  end
end
