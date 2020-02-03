class DockerCompose < Formula
  include Language::Python::Virtualenv

  desc "Isolated development environments using Docker"
  homepage "https://docs.docker.com/compose/"
  url "https://github.com/docker/compose/archive/1.25.4.tar.gz"
  sha256 "844a3d9c9ad13f1227bd828b3693dfb2001dcaea14de7c2a71f8aee47dbf19a7"
  head "https://github.com/docker/compose.git"

  bottle do
    cellar :any
    sha256 "1f34a9257cff68dd4764b303e32b424ab073b56aa989f77d50aa58718e566ad9" => :catalina
    sha256 "d336872d071071db819007dc54a9557915e610a79d76fc55f55bb80467841147" => :mojave
    sha256 "20814632cf2478e2560b86f27a119c6ca5f96d89537ef30e5820b56f85ea1fdd" => :high_sierra
  end

  depends_on "libyaml"
  depends_on "python@3.8"

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
