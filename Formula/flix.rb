class Flix < Formula
  desc "Statically typed functional, imperative, and logic programming language"
  homepage "https://flix.dev/"
  url "https://github.com/flix/flix/archive/refs/tags/v0.30.0.tar.gz"
  sha256 "25a3874e3c58f96b858f48da83f2a3dad77d7b14443e8d38fde01b8c370e0e7a"
  license "Apache-2.0"
  head "https://github.com/flix/flix.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?\.?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/flix"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "56c3d2a1fc00fefdc59517640f97e85f1d631cca48bcb6e40e9f23f56426217f"
  end

  depends_on "gradle" => :build
  depends_on "scala" => :build
  depends_on "openjdk"

  def install
    system Formula["gradle"].bin/"gradle", "build", "jar"
    prefix.install "build/libs/flix-#{version}.jar"
    bin.write_jar_script prefix/"flix-#{version}.jar", "flix"
  end

  test do
    system bin/"flix", "init"
    assert_match "Hello World!", shell_output("#{bin/"flix"} run")
    assert_match "Tests Passed!", shell_output("#{bin/"flix"} test")
  end
end
