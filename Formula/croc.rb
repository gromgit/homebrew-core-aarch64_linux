class Croc < Formula
  desc "Securely send things from one computer to another"
  homepage "https://github.com/schollz/croc"
  url "https://github.com/schollz/croc/archive/v8.3.1.tar.gz"
  sha256 "336b6c3ce3930e50326341c9131fd1f2ea207a33b331b0b6d3ce00bc324445f3"
  license "MIT"
  head "https://github.com/schollz/croc.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "3934c4ebae77c48c8e81382b97d744680432fee5b4eaaffb2f57f2a45df5ef39" => :catalina
    sha256 "e746dc794607003225810bf4ea74d59e285311eb17169a5da876710a5cb0c5ea" => :mojave
    sha256 "3a9f7d2c3618437c616a35b16a20b232c690a7129d4f0ce43f6fa729d5ec6df4" => :high_sierra
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
