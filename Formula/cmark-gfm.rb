class CmarkGfm < Formula
  desc "C implementation of GitHub Flavored Markdown"
  homepage "https://github.com/github/cmark-gfm"
  url "https://github.com/github/cmark-gfm/archive/0.29.0.gfm.5.tar.gz"
  version "0.29.0.gfm.5"
  sha256 "f665079062e05abc44ae933a74f1bdc5c89af1e1d2f4152042fc1ec5571093fe"
  license "BSD-2-Clause"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/cmark-gfm"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "ff1e29e1f67861925c5fba4b5afedb63c62a5c92f656401c0b441432d4130cd1"
  end

  depends_on "cmake" => :build
  depends_on "python@3.10" => :build

  conflicts_with "cmark", because: "both install a `cmark.h` header"

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args, "-DCMAKE_INSTALL_RPATH=#{rpath}"
      system "make", "install"
    end
  end

  test do
    output = pipe_output("#{bin}/cmark-gfm --extension autolink", "https://brew.sh")
    assert_equal '<p><a href="https://brew.sh">https://brew.sh</a></p>', output.chomp
  end
end
