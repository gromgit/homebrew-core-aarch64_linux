class Goplus < Formula
  desc "Programming language for engineering, STEM education, and data science"
  homepage "https://goplus.org"
  url "https://github.com/goplus/gop/archive/v1.1.3.tar.gz"
  sha256 "11e676f1ff4a391248747bad9d4c1673d366fcf306bd3e185fee5870afd02fee"
  license "Apache-2.0"
  head "https://github.com/goplus/gop.git", branch: "main"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/goplus"
    sha256 aarch64_linux: "0bec0f444a1bb8e66755f0f25eadba86802e78dda520d077b8364b796833f138"
  end

  depends_on "go"

  def install
    ENV["GOPROOT_FINAL"] = libexec
    system "go", "run", "cmd/make.go", "--install"

    libexec.install Dir["*"] - Dir[".*"]
    bin.install_symlink (libexec/"bin").children
  end

  test do
    (testpath/"hello.gop").write <<~EOS
      println("Hello World")
    EOS

    # Run gop fmt, run, build
    ENV.prepend "GO111MODULE", "on"

    assert_equal "v#{version}", shell_output("#{bin}/gop env GOPVERSION").chomp unless head?
    system bin/"gop", "fmt", "hello.gop"
    assert_equal "Hello World\n", shell_output("#{bin}/gop run hello.gop")

    (testpath/"go.mod").write <<~EOS
      module hello
    EOS

    system "go", "get", "github.com/goplus/gop/builtin"
    system bin/"gop", "build", "-o", "hello"
    assert_equal "Hello World\n", shell_output("./hello")
  end
end
