class Libpipeline < Formula
  desc "C library for manipulating pipelines of subprocesses"
  homepage "http://libpipeline.nongnu.org/"
  url "https://download.savannah.gnu.org/releases/libpipeline/libpipeline-1.5.3.tar.gz"
  sha256 "5dbf08faf50fad853754293e57fd4e6c69bb8e486f176596d682c67e02a0adb0"
  license "GPL-3.0-or-later"

  def install
    system "./configure", *std_configure_args, "--disable-silent-rules"
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <pipeline.h>
      int main() {
        pipeline *p = pipeline_new();
        pipeline_command_args(p, "echo", "Hello world", NULL);
        pipeline_command_args(p, "cat", NULL);
        return pipeline_run(p);
      }
    EOS
    system ENV.cc, "-I#{include}", "-L#{lib}", "-lpipeline", "test.c", "-o", "test"
    assert_match "Hello world", shell_output("./test")
  end
end
