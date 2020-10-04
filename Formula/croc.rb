class Croc < Formula
  desc "Securely send things from one computer to another"
  homepage "https://github.com/schollz/croc"
  url "https://github.com/schollz/croc/archive/v8.4.0.tar.gz"
  sha256 "7818976d1c773f79c4f92f83693ee4c02fc57852d99dfb09548427953c2b8fb3"
  license "MIT"
  head "https://github.com/schollz/croc.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "bfe4279811d75721783d9520624a3fad5dad6ec4c42a137739f9ee41cb6fc8b4" => :catalina
    sha256 "37c0dadd4b25960ed73023349d5ef0a5a801511024d9645e3b5f5e35fd665a1e" => :mojave
    sha256 "a2d60d1dc32f4c3798860e54208cd89d5f0a4e881861a33c9a93c7fa523c087d" => :high_sierra
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
