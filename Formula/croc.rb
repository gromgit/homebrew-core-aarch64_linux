class Croc < Formula
  desc "Securely send things from one computer to another"
  homepage "https://github.com/schollz/croc"
  url "https://github.com/schollz/croc/archive/v8.6.3.tar.gz"
  sha256 "595d0f1cf2a763572c2afc49eea3dd562e0c795dd7c2b2dea7e9a99a894882b8"
  license "MIT"
  head "https://github.com/schollz/croc.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "99ac28870cd04d0dbbfdf59e920045ec65429540b3f765832375d05cf2d9194e" => :catalina
    sha256 "1946a4759256f63bb2843a7af2666996e80b6f2235965bbeca03b0745eccd7db" => :mojave
    sha256 "38327206c1bb5ae44f38d76ea06bd55491d8e566a8314b20aa822aed74537956" => :high_sierra
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
