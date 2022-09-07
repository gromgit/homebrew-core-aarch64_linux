class Miller < Formula
  desc "Like sed, awk, cut, join & sort for name-indexed data such as CSV"
  homepage "https://github.com/johnkerl/miller"
  url "https://github.com/johnkerl/miller/releases/download/v6.2.0/miller-6.2.0.tar.gz"
  sha256 "da26531fe9bca1c1917ea41dd1f1d7338c61f50275ad3ea41d3bc4685da34687"
  license "BSD-2-Clause"
  head "https://github.com/johnkerl/miller.git", branch: "main"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/miller"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "0e0f7475e7934f1bfd72f4a0c5fa5bae4d9b710e4cafa24b18ea1961640d3cd2"
  end

  depends_on "go" => :build

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.csv").write <<~EOS
      a,b,c
      1,2,3
      4,5,6
    EOS
    output = pipe_output("#{bin}/mlr --csvlite cut -f a test.csv")
    assert_match "a\n1\n4\n", output
  end
end
