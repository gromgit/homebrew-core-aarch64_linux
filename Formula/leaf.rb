class Leaf < Formula
  desc "General purpose reloader for all projects"
  homepage "https://pkg.go.dev/github.com/vrongmeal/leaf"
  url "https://github.com/vrongmeal/leaf/archive/v1.3.0.tar.gz"
  sha256 "00ba86c1670e4a547d6f584350d41d174452d0679be25828e7835a8da1fe100a"
  license "MIT"
  head "https://github.com/vrongmeal/leaf.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/leaf"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "8b8c75ffacb1c77a912019395a80eca502d38489acf7b952d6c0c7bc086a5c62"
  end

  # Bump to 1.18 on the next release, if possible.
  depends_on "go@1.17" => :build

  conflicts_with "leaf-proxy", because: "both install `leaf` binaries"

  def install
    system "go", "build", *std_go_args, "./cmd/leaf/main.go"
  end

  test do
    (testpath/"a").write "foo"
    fork do
      exec bin/"leaf", "-f", "+ a", "-x", "cp a b"
    end
    sleep 1

    assert_equal (testpath/"a").read, (testpath/"b").read
    (testpath/"a").append_lines "bar"
    sleep 1

    assert_equal (testpath/"a").read, (testpath/"b").read
  end
end
