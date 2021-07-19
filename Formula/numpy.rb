class Numpy < Formula
  desc "Package for scientific computing with Python"
  homepage "https://www.numpy.org/"
  url "https://files.pythonhosted.org/packages/0b/a7/e724c8df240687b5fd62d8c71f1a6709d455c4c09432c7412e3e64f4cbe5/numpy-1.21.1.zip"
  sha256 "dff4af63638afcc57a3dfb9e4b26d434a7a602d225b42d746ea7fe2edf1342fd"
  license "BSD-3-Clause"
  head "https://github.com/numpy/numpy.git"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "88df8a9ea03e217ed2d648eaacd541003f15437bbe9a575ed3b4c0c8a123efd0"
    sha256 cellar: :any, big_sur:       "303ca5f3bfe16812f0f2fead2b29230906752032d45014a6e972a698ff8922f4"
    sha256 cellar: :any, catalina:      "66b7372569ec253cb81ab172903dbed96495cbca2452d41119867161bfd4433a"
    sha256 cellar: :any, mojave:        "f34cc0cd3046377a5640147f4adc26be75dcfc36dbeee92dc71147cc9e85c5f9"
    sha256               x86_64_linux:  "55238d0ac9a1dd50de3eca4586c5bdeb327fbdb3f3e0a2d9db5d63e86b64b570"
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
