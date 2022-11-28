class Brainfuck < Formula
  desc "Interpreter for the brainfuck language"
  homepage "https://github.com/fabianishere/brainfuck"
  url "https://github.com/fabianishere/brainfuck/archive/2.7.3.tar.gz"
  sha256 "d99be61271b4c27e26a8154151574aa3750133a0bedd07124b92ccca1e03b5a7"
  license "Apache-2.0"
  head "https://github.com/fabianishere/brainfuck.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/brainfuck"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "55be42dafc5fdb53a5b24e7231cb166ae08593278f53bb81f719f5780d9fc1ab"
  end


  depends_on "cmake" => :build

  uses_from_macos "libedit"

  def install
    system "cmake", ".", *std_cmake_args, "-DBUILD_SHARED_LIB=ON",
                         "-DBUILD_STATIC_LIB=ON", "-DINSTALL_EXAMPLES=ON"
    system "make", "install"
  end

  test do
    output = shell_output("#{bin}/brainfuck -e '++++++++[>++++++++<-]>+.+.+.'")
    assert_equal "ABC", output.chomp
  end
end
