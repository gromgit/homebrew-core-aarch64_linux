class Gflags < Formula
  desc "Library for processing command-line flags"
  homepage "https://gflags.github.io/gflags/"
  url "https://github.com/gflags/gflags/archive/v2.2.2.tar.gz"
  sha256 "34af2f15cf7367513b352bdcd2493ab14ce43692d2dcd9dfc499492966c64dcf"
  license "BSD-3-Clause"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/gflags"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "962dba75dc70c93beca414f1eb7a4050ccb4fa3ae6ec1a40e006dca0022318de"
  end


  depends_on "cmake" => :build

  def install
    mkdir "buildroot" do
      system "cmake", "..", *std_cmake_args, "-DBUILD_SHARED_LIBS=ON"
      system "make", "install"
    end
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <iostream>
      #include "gflags/gflags.h"

      DEFINE_bool(verbose, false, "Display program name before message");
      DEFINE_string(message, "Hello world!", "Message to print");

      static bool IsNonEmptyMessage(const char *flagname, const std::string &value)
      {
        return value[0] != '\0';
      }
      DEFINE_validator(message, &IsNonEmptyMessage);

      int main(int argc, char *argv[])
      {
        gflags::SetUsageMessage("some usage message");
        gflags::SetVersionString("1.0.0");
        gflags::ParseCommandLineFlags(&argc, &argv, true);
        if (FLAGS_verbose) std::cout << gflags::ProgramInvocationShortName() << ": ";
        std::cout << FLAGS_message;
        gflags::ShutDownCommandLineFlags();
        return 0;
      }
    EOS
    system ENV.cxx, "test.cpp", "-L#{lib}", "-lgflags", "-o", "test"
    assert_match "Hello world!", shell_output("./test")
    assert_match "Foo bar!", shell_output("./test --message='Foo bar!'")
  end
end
