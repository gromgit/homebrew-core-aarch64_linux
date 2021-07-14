class Pure < Formula
  desc "Pretty, minimal and fast ZSH prompt"
  homepage "https://github.com/sindresorhus/pure"
  url "https://github.com/sindresorhus/pure/archive/v1.17.0.tar.gz"
  sha256 "7a3dfec47b23a5e849a907b83dac4fb057beb9e0638b71f061b0fabea6a83c70"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "fad4c58ecdf6482925f0c30e5e2da9d48e6f6508b57c95ecfa71c5dfe96e0b19"
  end

  depends_on "zsh" => :test
  depends_on "zsh-async"

  def install
    zsh_function.install "pure.zsh" => "prompt_pure_setup"
  end

  test do
    zsh_command = "setopt prompt_subst; autoload -U promptinit; promptinit && prompt -p pure"
    assert_match "❯", shell_output("zsh -c '#{zsh_command}'")
  end
end
