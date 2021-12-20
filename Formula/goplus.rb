class Goplus < Formula
  desc "Programming language for engineering, STEM education, and data science"
  homepage "https://goplus.org"
  url "https://github.com/goplus/gop/archive/v1.0.37.tar.gz"
  sha256 "edbb7eb99f175423d583de156967b5d9ae632b2fe405b6c1a36ede47591d7dd5"
  license "Apache-2.0"
  head "https://github.com/goplus/gop.git", branch: "main"

  bottle do
    sha256 arm64_monterey: "182857f41722e0223f0758e141d833c7a4834caf5f219ed9c0ab7805b9b1f94a"
    sha256 arm64_big_sur:  "da84a32df9bb0cc93a92f4bb51f0c62f9a1cbd5924ca2d52064f5952763bcb7b"
    sha256 monterey:       "b8ca30a9f894b819e0fe1ca3d1e47735b060a5998de720531d2dd09cb1260f7d"
    sha256 big_sur:        "46d2e38a02ad048973c079bfd558496b90c421c95e2b6eb1ca7c5ebd04c8a47b"
    sha256 catalina:       "c4bb661a6e32d70532ef679a041d38a02e8e9459c7d99c925b99d46e6b553576"
    sha256 x86_64_linux:   "85a68dcb21af69102ea244409e328fec517b7638f74f1241c1132d3bb3460b81"
  end

  depends_on "go"

  def install
    # Patch version to match the version of gop, currently it get version from git tag
    inreplace "env/version.go", /^\tbuildVersion string$/, "\tbuildVersion string = \"v#{version}\"" unless build.head?

    ENV["GOPROOT_FINAL"] = libexec
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
