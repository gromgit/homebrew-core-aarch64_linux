class Cython < Formula
  desc "Compiler for writing C extensions for the Python language"
  homepage "https://cython.org/"
  url "https://files.pythonhosted.org/packages/4f/94/15b333b182ce12c76e2da888d608edd472f617bafcd8d1bb857c18faac3e/Cython-0.29.18.tar.gz"
  sha256 "46e9ab055eb64595f160b61037c3e65ce0b01320d144a3a53eb807000078d53f"

  bottle do
    cellar :any_skip_relocation
    sha256 "455c4cd359953316efd863deadbae2d31ce609b6405e8988956e51cae2fc78c7" => :catalina
    sha256 "7428bd4b244bf73a9bb9875805d40f54a591da31f60d75eb9faafa2ac13f1e5a" => :mojave
    sha256 "8ce10419c6c2e6ff485cc45641b7d3af43ed3b6b120d3f2494d93f2b317914f5" => :high_sierra
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
