class Gaze < Formula
  desc "Execute commands for you"
  homepage "https://github.com/wtetsu/gaze"
  url "https://github.com/wtetsu/gaze/archive/refs/tags/v1.1.3.tar.gz"
  sha256 "53c46a09f477433e9105b9df8db9ddf287fae6734b3078d79f5f994500e8625d"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/gaze"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "1ee162650320add269d71f5992c794aa1a4030b42e1ed6955efe5a431d3e5b35"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "cmd/gaze/main.go"
  end

  test do
    pid = fork do
      exec bin/"gaze", "-c", "cp test.txt out.txt", "test.txt"
    end
    sleep 5
    File.write("test.txt", "hello, world!")
    sleep 2
    Process.kill("TERM", pid)
    assert_match("hello, world!", File.read("out.txt"))
  end
end
