class PythonTkAT39 < Formula
  desc "Python interface to Tcl/Tk"
  homepage "https://www.python.org/"
  url "https://www.python.org/ftp/python/3.9.13/Python-3.9.13.tar.xz"
  sha256 "125b0c598f1e15d2aa65406e83f792df7d171cdf38c16803b149994316a3080f"
  license "Python-2.0"

  livecheck do
    formula "python@3.9"
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/python-tk@3.9"
    sha256 aarch64_linux: "de481b09271b811a59a47696ee094421bbbc7694acf75b40b67fd50d0bbfd527"
  end

  depends_on "python@3.9"
  depends_on "tcl-tk"

  def install
    cd "Modules" do
      tcltk_version = Formula["tcl-tk"].any_installed_version.major_minor
      (Pathname.pwd/"setup.py").write <<~EOS
        from setuptools import setup, Extension

        setup(name="tkinter",
              description="#{desc}",
              version="#{version}",
              ext_modules = [
                Extension("_tkinter", ["_tkinter.c", "tkappinit.c"],
                          define_macros=[("WITH_APPINIT", 1)],
                          include_dirs=["#{Formula["tcl-tk"].opt_include}"],
                          libraries=["tcl#{tcltk_version}", "tk#{tcltk_version}"],
                          library_dirs=["#{Formula["tcl-tk"].opt_lib}"])
              ]
        )
      EOS
      system "python3.9", *Language::Python.setup_install_args(libexec), "--install-lib=#{libexec}"
      rm_r libexec.glob("*.egg-info")
    end
  end

  test do
    system "python3.9", "-c", "import tkinter"

    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    system "python3.9", "-c", "import tkinter; root = tkinter.Tk()"
  end
end
