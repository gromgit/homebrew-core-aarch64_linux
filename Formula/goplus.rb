class Goplus < Formula
  desc "Programming language for engineering, STEM education, and data science"
  homepage "https://goplus.org"
  url "https://github.com/goplus/gop/archive/v1.0.38.tar.gz"
  sha256 "32f364e648f1f1509f04e37925cc98b373a58775d751bdcb9ded7cfd3d57478a"
  license "Apache-2.0"
  head "https://github.com/goplus/gop.git", branch: "main"

  bottle do
    sha256 arm64_monterey: "364bc9cf7f85ec369779d6538cb90ba6c9775861833558ff71a13955b3efa898"
    sha256 arm64_big_sur:  "c32b2c24352f2b8da22c89e307a147c4ee7e3bc4c584814e7de727e388c6edef"
    sha256 monterey:       "89660707153e9b21e0f6c32eb5baa38a72d73eb2b72c280e7ce4d62cfb0d196f"
    sha256 big_sur:        "952bbd492a21f5e9a52982de28f143d6ee2994cd6df6362d303a98731aa2efa5"
    sha256 catalina:       "ed6b409487a216ea24e792bd29159c3e82e518fa1730b67c352cb3af27bb2bb8"
    sha256 x86_64_linux:   "6a9f23c71bc0197d91ddb81ae4c003bb88445b8289c95952ff181a5b9fc0f778"
  end

  depends_on "go"

  def install
    ENV["GOPROOT_FINAL"] = libexec
    (buildpath/"VERSION").write "v#{version}"
    system "go", "run", "cmd/make.go", "--install"

    libexec.install Dir["*"] - Dir[".*"]
    bin.install_symlink Dir[libexec/"bin/*"]
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
