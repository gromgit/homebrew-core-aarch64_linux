class Conan < Formula
  include Language::Python::Virtualenv

  desc "Distributed, open source, package manager for C/C++"
  homepage "https://github.com/conan-io/conan"
  url "https://github.com/conan-io/conan/archive/1.22.2.tar.gz"
  sha256 "8946803732cf435dab8100bbd16c682fe8ca9e0c7dc93708845d226fcd2581b9"
  head "https://github.com/conan-io/conan.git"

  bottle do
    cellar :any
    sha256 "6b3d675090e53aa0030b57fcad42cdf7ed3cec169a4f82e048e77b8fd866befe" => :catalina
    sha256 "a0f66c9297cb3b8355275cb155ef1e0f3bf36f67e07c496defa115c373ec5067" => :mojave
    sha256 "1890b44353f00dea04054958ef54b2e2d3fdc396153ff3b6983e3be355026bcb" => :high_sierra
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
