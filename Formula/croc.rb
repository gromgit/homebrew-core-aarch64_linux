class Croc < Formula
  desc "Securely send things from one computer to another"
  homepage "https://github.com/schollz/croc"
  url "https://github.com/schollz/croc/archive/v8.6.3.tar.gz"
  sha256 "595d0f1cf2a763572c2afc49eea3dd562e0c795dd7c2b2dea7e9a99a894882b8"
  license "MIT"
  head "https://github.com/schollz/croc.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "730ff98e54ac8663b482eef9e6ebf8c2726cb40eb82b9da1ceca98ae4dba84af" => :catalina
    sha256 "8f62a6d88a2120089d2eac0af15446ec0d952a43bc8de8aac590cabcb1ff216e" => :mojave
    sha256 "f71a16b93ec5590bf5ffbf7ceaf07fc3d046f94d4a95f183fee0ed053161c9f6" => :high_sierra
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
