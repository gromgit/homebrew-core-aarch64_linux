class Bingrep < Formula
  desc "Greps through binaries from various OSs and architectures"
  homepage "https://github.com/m4b/bingrep"
  url "https://github.com/m4b/bingrep/archive/v0.8.2.tar.gz"
  sha256 "5647d78166a2d768b98ae03bd40427f2263b28b81213882d42f638c5b96619e2"

  bottle do
    cellar :any_skip_relocation
    sha256 "c370465c0e36f286d7051007df4cc8e9830f68e8b04ca1b41471396ab5bd3300" => :catalina
    sha256 "9f15cee5770b2bab318aac00b20c60f2b82c81881d99f934420c863c64bc2295" => :mojave
    sha256 "352b163b9239facdfe846d9eb0d0c73f50d2681ced80645ecdd69818942dcfed" => :high_sierra
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--locked", "--root", prefix, "--path", "."
  end

  test do
    system bin/"bingrep", bin/"bingrep"
  end
end
