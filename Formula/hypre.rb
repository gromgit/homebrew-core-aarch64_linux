class Hypre < Formula
  desc "Library featuring parallel multigrid methods for grid problems"
  homepage "https://computation.llnl.gov/casc/hypre/software.html"
  url "https://github.com/hypre-space/hypre/archive/v2.20.0.tar.gz"
  sha256 "5be77b28ddf945c92cde4b52a272d16fb5e9a7dc05e714fc5765948cba802c01"
  # license ["MIT", "Apache-2.0"] - pending https://github.com/Homebrew/brew/pull/7953
  license "MIT"
  head "https://github.com/hypre-space/hypre.git"

  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "9bba59afd174afc5ebb884369445639d9aae27bf5894ecd65e8f113d33c4f89f" => :catalina
    sha256 "b8e38313cbf6a6a5ca0ad3605c51f70efea2687f9d8fa299e525b927b43544be" => :mojave
    sha256 "135e5998b03eb58b4f4a7363c01014a74362c93daad5b8720b9081b5a65caeb9" => :high_sierra
  end

  depends_on "gcc" # for gfortran
  depends_on "open-mpi"

  def install
    cd "src" do
      system "./configure", "--prefix=#{prefix}",
                            "--with-MPI",
                            "--enable-bigint"
      system "make", "install"
    end
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include "HYPRE_struct_ls.h"
      int main(int argc, char* argv[]) {
        HYPRE_StructGrid grid;
      }
    EOS

    system ENV.cc, "test.cpp", "-o", "test"
    system "./test"
  end
end
