class Cython < Formula
  desc "Compiler for writing C extensions for the Python language"
  homepage "https://cython.org/"
  url "https://files.pythonhosted.org/packages/3f/61/16a435de52fcda15246597a602aab6132cea50bedeb0919cb8874a068a20/Cython-0.29.20.tar.gz"
  sha256 "22d91af5fc2253f717a1b80b8bb45acb655f643611983fd6f782b9423f8171c7"

  bottle do
    cellar :any_skip_relocation
    sha256 "faaf677dba9dabd0743bda5c369559a147225edb9d5c73fdd708400e0753d52c" => :catalina
    sha256 "08cdc1c4a364a931965ae85df0b973d056a46c365f1d072f6f16ddf5c5f63a9a" => :mojave
    sha256 "2f85d3bdf5028c787e9d94e5ef3a751d119617001153b632f8f15fc73c473121" => :high_sierra
  end

  keg_only <<~EOS
    this formula is mainly used internally by other formulae.
    Users are advised to use `pip` to install cython
  EOS

  depends_on "python@3.8"

  def install
    xy = Language::Python.major_minor_version Formula["python@3.8"].opt_bin/"python3"
    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python#{xy}/site-packages"
    system Formula["python@3.8"].opt_bin/"python3", *Language::Python.setup_install_args(libexec)

    bin.install Dir[libexec/"bin/*"]
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    xy = Language::Python.major_minor_version Formula["python@3.8"].opt_bin/"python3"
    ENV.prepend_path "PYTHONPATH", libexec/"lib/python#{xy}/site-packages"

    phrase = "You are using Homebrew"
    (testpath/"package_manager.pyx").write "print '#{phrase}'"
    (testpath/"setup.py").write <<~EOS
      from distutils.core import setup
      from Cython.Build import cythonize

      setup(
        ext_modules = cythonize("package_manager.pyx")
      )
    EOS
    system Formula["python@3.8"].opt_bin/"python3", "setup.py", "build_ext", "--inplace"
    assert_match phrase, shell_output("#{Formula["python@3.8"].opt_bin}/python3 -c 'import package_manager'")
  end
end
