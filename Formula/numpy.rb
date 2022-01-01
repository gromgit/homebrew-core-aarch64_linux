class Numpy < Formula
  desc "Package for scientific computing with Python"
  homepage "https://www.numpy.org/"
  url "https://files.pythonhosted.org/packages/50/e1/9b0c184f04b8cf5f3c941ffa56fbcbe936888bdac9aa7ba6bae405ac752b/numpy-1.22.0.zip"
  sha256 "a955e4128ac36797aaffd49ab44ec74a71c11d6938df83b1285492d277db5397"
  license "BSD-3-Clause"
  head "https://github.com/numpy/numpy.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_monterey: "1c2d8b6b6fb3b6e717c3e360bf35667b5dea5341ca9f30a1ea5d9ea93e206320"
    sha256 cellar: :any, arm64_big_sur:  "583589487451f41b81fe238c3e1eaa7437fabfd7ffe1ce68917e727ac763a98a"
    sha256 cellar: :any, monterey:       "bea28b41abc0001c354dc435308eabaf246f132dd369aab26ab4d53c92e5f1e7"
    sha256 cellar: :any, big_sur:        "954442b9e73986fc548149abd84e9c2a6999186bd673f11c5744e57ac24b6130"
    sha256 cellar: :any, catalina:       "82051930b6fc4187db9935b9ca6c5070157499ef52aae2fa08afbb417b60b89f"
    sha256               x86_64_linux:   "2a51cd17e7b25e1639015c0c2009f99a25e9b7c69b8c90934612c5c73bcb7c55"
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
