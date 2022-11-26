class Securefs < Formula
  desc "Filesystem with transparent authenticated encryption"
  homepage "https://github.com/netheril96/securefs"
  url "https://github.com/netheril96/securefs.git",
      tag:      "0.13.1",
      revision: "bb7088e3fe43cd5978ec6b09b4cd9615a4ab654c"
  license "MIT"
  head "https://github.com/netheril96/securefs.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, x86_64_linux: "99d70dae414d78c230684f94f42cc2f36c5a8f1934c3eb066b687e199866c421"
  end

  depends_on "cmake" => :build
  depends_on "libfuse@2"
  depends_on :linux # on macOS, requires closed-source macFUSE

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system "#{bin}/securefs", "version" # The sandbox prevents a more thorough test
  end
end
