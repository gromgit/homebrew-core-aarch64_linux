class CondaZshCompletion < Formula
  desc "Zsh completion for conda"
  homepage "https://github.com/conda-incubator/conda-zsh-completion"
  url "https://github.com/conda-incubator/conda-zsh-completion/archive/refs/tags/v0.9.tar.gz"
  sha256 "beb79bfe083551628cad3fe6bb6e39cd638c1c44f83a3c9c7f251ec4d20b5ade"
  license "WTFPL"
  head "https://github.com/conda-incubator/conda-zsh-completion.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/conda-zsh-completion"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "3054235fb7aa54ee4afaa78054b89138d66520dd12f18ce11070fd96fdc66d37"
  end

  uses_from_macos "zsh" => :test

  def install
    zsh_completion.install "_conda"
  end

  test do
    assert_match(/^_conda \(\) \{/,
      shell_output("zsh -c 'fpath=(#{zsh_completion} $fpath); autoload _conda; which _conda'"))
  end
end
