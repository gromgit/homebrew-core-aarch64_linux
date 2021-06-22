class Croc < Formula
  desc "Securely send things from one computer to another"
  homepage "https://github.com/schollz/croc"
  url "https://github.com/schollz/croc/archive/v9.2.0.tar.gz"
  sha256 "e8f72be7f3c26a1c4ed00c3ebb222d2959cd6c7f7f74a097a556b56e6a24ba96"
  license "MIT"
  head "https://github.com/schollz/croc.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "d2aa372def85f9b7ae9bc63ba5cc7feaaf0aeed0abaa81e33f0df2d7271dccb9"
    sha256 cellar: :any_skip_relocation, big_sur:       "76d3affb94b1f27e5d8a4545a6c65a2726f2439acc39b90a9ae81c694509ac66"
    sha256 cellar: :any_skip_relocation, catalina:      "82317dc95095c700b6beae881825b3f77a749e0b91d66b60112f67aec7ca0f88"
    sha256 cellar: :any_skip_relocation, mojave:        "5f37a0d247ab31c29335c8bba807dfa5b57fbb6f76a77a443aef998625a79319"
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
