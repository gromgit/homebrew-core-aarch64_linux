class DockerComposeCompletion < Formula
  desc "Completion script for docker-compose"
  homepage "https://docs.docker.com/compose/completion/"
  url "https://github.com/docker/compose/archive/1.29.1.tar.gz"
  sha256 "c132b6be73f7816c0fc5af15be0fe0e9a8d2fe31d1f31de73dedc229e344bb27"
  license "Apache-2.0"
  head "https://github.com/docker/compose.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "1ab2201f38ad9a46439d9ee4cd28855fa46da131292888053fa3aeb0ac4bbf3f"
  end

  conflicts_with "docker-compose",
    because: "docker-compose already includes completion scripts"

  def install
    bash_completion.install "contrib/completion/bash/docker-compose"
    fish_completion.install "contrib/completion/fish/docker-compose.fish"
    zsh_completion.install "contrib/completion/zsh/_docker-compose"
  end

  test do
    assert_match "-F _docker_compose",
      shell_output("bash -c 'source #{bash_completion}/docker-compose && complete -p docker-compose'")
  end
end
