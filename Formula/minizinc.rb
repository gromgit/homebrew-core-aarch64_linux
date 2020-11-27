class Minizinc < Formula
  desc "Medium-level constraint modeling language"
  homepage "https://www.minizinc.org/"
  url "https://github.com/MiniZinc/libminizinc/archive/2.5.3.tar.gz"
  sha256 "07982723009fcb50ae190bf17277e8c91e6279f319521f571d253ba27e2c2b1b"
  license "MPL-2.0"
  head "https://github.com/MiniZinc/libminizinc.git", branch: "develop"

  bottle do
    cellar :any_skip_relocation
    sha256 "7ac9febf204521d16f570a84ebe3f25ba7e1393f33771dd842287b415afa97fe" => :big_sur
    sha256 "39365070e4c1a7e1f2834e367409c3aebbd62b1519e2cb63e0b665c5afaf7b01" => :catalina
    sha256 "97cc0f4bee19660cbf54fdd55dd8600640a2c18a43ca39822b3c4b87f78f3f8d" => :mojave
  end

  depends_on "cmake" => :build
  depends_on arch: :x86_64

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "cmake", "--build", ".", "--target", "install"
    end
  end

  test do
    system bin/"mzn2doc", pkgshare/"std/all_different.mzn"
  end
end
