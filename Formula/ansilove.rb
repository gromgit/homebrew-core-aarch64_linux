class Ansilove < Formula
  desc "ANSI/ASCII art to PNG converter"
  homepage "https://www.ansilove.org"
  url "https://github.com/ansilove/ansilove/releases/download/4.1.5/ansilove-4.1.5.tar.gz"
  sha256 "dcc6e82fab1587a0f556ee64a6cda9c91dcaaa37306cccc4a4d25f7c96b04d19"
  license "BSD-2-Clause"

  depends_on "cmake" => :build
  depends_on "gd"

  resource "libansilove" do
    url "https://github.com/ansilove/libansilove/releases/download/1.2.8/libansilove-1.2.8.tar.gz"
    sha256 "ef02eda605e3b38edbeac5874f2de22201db123cb7aab9228fd05cb288d0c0bc"
  end

  def install
    resource("libansilove").stage do
      system "cmake", "-S", ".", "-B", "build", *std_cmake_args
      system "cmake", "--build", "build"
      system "cmake", "--install", "build"
    end

    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    pkgshare.install "examples/burps/bs-ansilove.ans" => "test.ans"
  end

  test do
    output = shell_output("#{bin}/ansilove -o #{testpath}/output.png #{pkgshare}/test.ans")
    assert_match "Font: 80x25", output
    assert_match "Id: SAUCE v00", output
    assert_match "Tinfos: IBM VGA", output
    assert_predicate testpath/"output.png", :exist?
  end
end
