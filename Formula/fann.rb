class Fann < Formula
  desc "Fast artificial neural network library"
  homepage "https://sourceforge.net/projects/fann"
  url "https://downloads.sourceforge.net/project/fann/fann/2.2.0/FANN-2.2.0-Source.tar.gz"
  sha256 "3d6ee056dab91f3b34a3f233de6a15331737848a4cbdb4e0552123d95eed4485"
  license "LGPL-2.1-or-later"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/fann"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "5c4ef3a327a0f9d258972994d2ad9c3283781cd80105178e82ccb6af5d65fd0b"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"xor.data").write <<~EOS
      4 2 1
      -1 -1
      -1
      -1 1
      1
      1 -1
      1
      1 1
      -1
    EOS

    desired_error = 0.001
    max_epochs = 500000

    (testpath/"test.c").write <<~EOS
      #include <fann.h>
      int main()
      {
          const unsigned int num_input = 2;
          const unsigned int num_output = 1;
          const unsigned int num_layers = 3;
          const unsigned int num_neurons_hidden = 3;
          const float desired_error = (const float) #{desired_error};
          const unsigned int max_epochs = #{max_epochs};
          const unsigned int epochs_between_reports = 1000;
          struct fann *ann = fann_create_standard(num_layers, num_input,
              num_neurons_hidden, num_output);
          fann_set_activation_function_hidden(ann, FANN_SIGMOID_SYMMETRIC);
          fann_set_activation_function_output(ann, FANN_SIGMOID_SYMMETRIC);
          fann_train_on_file(ann, "xor.data", max_epochs,
              epochs_between_reports, desired_error);
          fann_save(ann, "xor_float.net");
          fann_destroy(ann);
          return 0;
      }
    EOS

    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lfann", "-lm", "-o", "test"
    output = shell_output(testpath/"test")
    epoch, error = output.lines.last.match(/Epochs\s+(\d+)\.\s+Current error:\s+(\d+\.\d+)\. Bit fail 0\./).captures

    assert epoch.to_i <= max_epochs
    assert error.to_f <= desired_error
    assert_predicate testpath/"xor_float.net", :exist?
  end
end
