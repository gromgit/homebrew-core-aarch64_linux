class BasisUniversal < Formula
  desc "Basis Universal GPU texture codec command-line compression tool"
  homepage "https://github.com/BinomialLLC/basis_universal"
  url "https://github.com/BinomialLLC/basis_universal/archive/refs/tags/1.16.3.tar.gz"
  sha256 "b89563aa5879eed20f56b9cfa03b52848e759531fd5a1d51a8f63c846f96c2ac"
  license "Apache-2.0"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/basis_universal"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "a5ca17e5f0a0bd37697e5e613b773867d3d1f695d41d0dea19ee8029f7c81dce"
  end


  depends_on "cmake" => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    system "#{bin}/basisu", test_fixtures("test.png")
    assert_predicate testpath/"test.basis", :exist?
  end
end
