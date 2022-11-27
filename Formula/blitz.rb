class Blitz < Formula
  desc "Multi-dimensional array library for C++"
  homepage "https://github.com/blitzpp/blitz/wiki"
  url "https://github.com/blitzpp/blitz/archive/1.0.2.tar.gz"
  sha256 "500db9c3b2617e1f03d0e548977aec10d36811ba1c43bb5ef250c0e3853ae1c2"
  license "Artistic-2.0"
  head "https://github.com/blitzpp/blitz.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/blitz"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "a9b005618325f5e4f9eb329a9699bec772f25cc10da0d800e1eebaea2caf8c15"
  end

  depends_on "cmake" => :build

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "lib"
      system "make", "install"
    end
  end

  test do
    (testpath/"testfile.cpp").write <<~EOS
      #include <blitz/array.h>
      #include <cstdlib>
      using namespace blitz;
      int main(){
        Array<float,2> A(3,1);
        A = 17, 2, 97;
        cout << "A = " << A << endl;
        return 0;}
    EOS
    system ENV.cxx, "testfile.cpp", "-o", "testfile"
    output = shell_output("./testfile")
    var = "/A\ =\ \(0,2\)\ x\ \(0,0\)\n\[\ 17\ \n\ \ 2\ \n\ \ 97\ \]\n\n/"
    assert_match output, var
  end
end
