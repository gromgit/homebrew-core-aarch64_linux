class Jshon < Formula
  desc "Parse, read, and create JSON from the shell"
  homepage "http://kmkeen.com/jshon/"
  url "https://github.com/keenerd/jshon/archive/20131105.tar.gz"
  sha256 "28420f6f02c6b762732898692cc0b0795cfe1a59fbfb24e67b80f332cf6d4fa2"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/jshon"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "247275692e3137e5ea11828d27c5b00e0521b0845511128ce9f1b6daee381376"
  end

  depends_on "jansson"

  def install
    system "make"
    bin.install "jshon"
    man1.install "jshon.1"
  end

  test do
    (testpath/"test.json").write <<~EOS
      {"a":1,"b":2}
    EOS

    assert_equal "2", pipe_output("#{bin}/jshon -l < test.json").strip
  end
end
