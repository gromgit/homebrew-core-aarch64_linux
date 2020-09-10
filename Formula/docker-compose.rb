class DockerCompose < Formula
  include Language::Python::Virtualenv

  desc "Isolated development environments using Docker"
  homepage "https://docs.docker.com/compose/"
  url "https://files.pythonhosted.org/packages/62/63/a0adc442f57aca3b6d8606b93dc43b0ec47bfb7e363157c88e27e5b2ccc2/docker-compose-1.27.0.tar.gz"
  sha256 "42553bb8b991b66ced557725714197f13a46d5626f8ab25d244000fbf4ee2d25"
  license "Apache-2.0"
  head "https://github.com/docker/compose.git"

  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    cellar :any
    sha256 "dc2582bb9fdd34077162655c2563101251515dd763ffdc81abe50fbfa20e3603" => :catalina
    sha256 "55a37ab5af752960225b870f7b1ea756f35e77192f06eaa814be0b839ce6afd8" => :mojave
    sha256 "ddb2c734cde1a98985d2d59522b9bcb51e205d32d31fea9e23be465df23cb618" => :high_sierra
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
