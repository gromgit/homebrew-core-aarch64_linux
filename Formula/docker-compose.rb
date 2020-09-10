class DockerCompose < Formula
  include Language::Python::Virtualenv

  desc "Isolated development environments using Docker"
  homepage "https://docs.docker.com/compose/"
  url "https://files.pythonhosted.org/packages/1e/99/64ef40259c9544d3ab74e8a2a3fc980cc07ee203d631771c28dedf76c837/docker-compose-1.27.2.tar.gz"
  sha256 "4675242b1bc3fc5b3a8ae367d34012e250ba413fd2815e365541104086488971"
  license "Apache-2.0"
  head "https://github.com/docker/compose.git"

  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    cellar :any
    sha256 "d821b37b02dc645105756021dba28b37126a7a8011fb656ea8546efdfc10826d" => :catalina
    sha256 "43fb2d4e8d3c9d769d0b42279fa54d8fa81b2f20bc44c82c5c1df5e7f6eaa69b" => :mojave
    sha256 "5b3a72e40215559a42e7c2569e308be44c64c8904dc23ee7f467da92c1bf6237" => :high_sierra
  end

  depends_on "libyaml"
  depends_on "python@3.8"

  uses_from_macos "libffi"

  def install
    system "./script/build/write-git-sha" if build.head?
    venv = virtualenv_create(libexec, "python3")
    system libexec/"bin/pip", "install", "-v", "--no-binary", ":all:",
                              "--ignore-installed", buildpath
    system libexec/"bin/pip", "uninstall", "-y", "docker-compose"
    venv.pip_install_and_link buildpath

    bash_completion.install "contrib/completion/bash/docker-compose"
    zsh_completion.install "contrib/completion/zsh/_docker-compose"
  end

  test do
    system bin/"docker-compose", "--help"
  end
end
