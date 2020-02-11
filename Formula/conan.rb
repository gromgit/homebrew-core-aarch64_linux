class Conan < Formula
  include Language::Python::Virtualenv

  desc "Distributed, open source, package manager for C/C++"
  homepage "https://github.com/conan-io/conan"
  url "https://github.com/conan-io/conan/archive/1.22.1.tar.gz"
  sha256 "4ee6f95a34b76d90703efabcc61d0cb64cf21570d31787aa4c7d96b8dc4ad938"
  head "https://github.com/conan-io/conan.git"

  bottle do
    cellar :any
    sha256 "a4ae1c668ddd81fe78f1b537431888a533582fbbeda8076b32538dc767ddd153" => :catalina
    sha256 "40e1d3c85c70e2f2c932a498c7b1f74489a636e4df35b0375cffa01ac0725ad4" => :mojave
    sha256 "9fea493e6241dc2ec3fa5e3c1fcfac8cab991b3e1ff94ce6f0fd757489a6b94a" => :high_sierra
  end

  depends_on "pkg-config" => :build
  depends_on "libffi"
  depends_on "openssl@1.1"
  depends_on "python@3.8"

  def install
    venv = virtualenv_create(libexec, "python3")
    system libexec/"bin/pip", "install", "-v", "--no-binary", ":all:",
                              "--ignore-installed", "PyYAML==3.13", buildpath
    system libexec/"bin/pip", "uninstall", "-y", name
    venv.pip_install_and_link buildpath
  end

  test do
    system bin/"conan", "install", "zlib/1.2.11@conan/stable", "--build"
    assert_predicate testpath/".conan/data/zlib/1.2.11", :exist?
  end
end
