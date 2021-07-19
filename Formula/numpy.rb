class Numpy < Formula
  desc "Package for scientific computing with Python"
  homepage "https://www.numpy.org/"
  url "https://files.pythonhosted.org/packages/0b/a7/e724c8df240687b5fd62d8c71f1a6709d455c4c09432c7412e3e64f4cbe5/numpy-1.21.1.zip"
  sha256 "dff4af63638afcc57a3dfb9e4b26d434a7a602d225b42d746ea7fe2edf1342fd"
  license "BSD-3-Clause"
  head "https://github.com/numpy/numpy.git"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "5b16358f9ed92c54d021da08b84cdd7246672cfd170371e8c0be78dd48d991c7"
    sha256 cellar: :any, big_sur:       "4e70f201e52c031492ad3389eb24f6c65803335de40224074467c3a7a31d13f8"
    sha256 cellar: :any, catalina:      "afd60142de082369b0ee822f4554d1478db244801c2003b2376143287eb4f417"
    sha256 cellar: :any, mojave:        "71b47356e79bc9b28f8126017278923a636325115da97e125da340ba6a90626c"
    sha256               x86_64_linux:  "65bcb382295c1c72eac8f597edc3debc6b0f272270109abbef6875eea9603bc3"
  end

  depends_on "cython" => :build
  depends_on "gcc" => :build # for gfortran
  depends_on "openblas"
  depends_on "python@3.9"

  fails_with gcc: "5"

  def install
    openblas = Formula["openblas"].opt_prefix
    ENV["ATLAS"] = "None" # avoid linking against Accelerate.framework
    ENV["BLAS"] = ENV["LAPACK"] = "#{openblas}/lib/#{shared_library("libopenblas")}"

    config = <<~EOS
      [openblas]
      libraries = openblas
      library_dirs = #{openblas}/lib
      include_dirs = #{openblas}/include
    EOS

    Pathname("site.cfg").write config

    xy = Language::Python.major_minor_version Formula["python@3.9"].opt_bin/"python3"
    ENV.prepend_create_path "PYTHONPATH", Formula["cython"].opt_libexec/"lib/python#{xy}/site-packages"

    system Formula["python@3.9"].opt_bin/"python3", "setup.py", "build",
        "--fcompiler=gfortran", "--parallel=#{ENV.make_jobs}"
    system Formula["python@3.9"].opt_bin/"python3", *Language::Python.setup_install_args(prefix)
  end

  test do
    system Formula["python@3.9"].opt_bin/"python3", "-c", <<~EOS
      import numpy as np
      t = np.ones((3,3), int)
      assert t.sum() == 9
      assert np.dot(t, t).sum() == 27
    EOS
  end
end
