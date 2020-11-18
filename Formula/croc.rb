class Croc < Formula
  desc "Securely send things from one computer to another"
  homepage "https://github.com/schollz/croc"
  url "https://github.com/schollz/croc/archive/v8.6.6.tar.gz"
  sha256 "fa1681180e884f0ed3d54c9a15dff90288b69663e485fd08fef38a063c83a7af"
  license "MIT"
  head "https://github.com/schollz/croc.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "23579d60130ae5ba026dc58fc909483051c9994c4a38780058dde8a282d0b466" => :big_sur
    sha256 "3bc651c2c8e2f807a68d48b2d25fe6bbcb8725595f08ba11eede1f30008a70f3" => :catalina
    sha256 "d0de80f9f4221c1de3240a03d7851bbfee5bb4c0842d4bb76f0689d14b682359" => :mojave
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args
  end

  test do
    fork do
      exec bin/"croc", "send", "--code=homebrew-test", "--text=mytext"
    end
    sleep 1

    assert_match shell_output("#{bin}/croc --yes homebrew-test").chomp, "mytext"
  end
end
