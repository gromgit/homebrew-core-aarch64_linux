class Smlpkg < Formula
  desc "Package manager for Standard ML libraries and programs"
  homepage "https://github.com/diku-dk/smlpkg"
  url "https://github.com/diku-dk/smlpkg/archive/v0.1.5.tar.gz"
  sha256 "53440d8b0166dd689330fc686738076225ac883a00b283e65394cf9312575c33"
  license "MIT"
  head "https://github.com/diku-dk/smlpkg.git"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, big_sur:  "fd459b66ca6600128d61f41aa636992d79bff55eb2685560649bf0b5a124a59e"
    sha256 cellar: :any_skip_relocation, catalina: "2ad06cae7d868c565f3c8eb8ca52ebdd01748bb89317467faea42359c19fae3b"
    sha256 cellar: :any_skip_relocation, mojave:   "e02a5edf96861f5b5c0a35540202ec9dafb4b1f94e56fce8cb7db351e93e238c"
  end

  depends_on "mlkit"

  def install
    system "make", "-C", "src", "smlpkg"
    system "make", "install", "prefix=#{prefix}"
  end

  test do
    expected_pkg = <<~EOS
      package github.com/diku-dk/testpkg

      require {
        github.com/diku-dk/sml-random 0.1.0 #8b329d10b0df570da087f9e15f3c829c9a1d74c2
      }
    EOS
    system bin/"smlpkg", "init", "github.com/diku-dk/testpkg"
    system bin/"smlpkg", "add", "github.com/diku-dk/sml-random", "0.1.0"
    assert_equal expected_pkg, (testpath/"sml.pkg").read
  end
end
