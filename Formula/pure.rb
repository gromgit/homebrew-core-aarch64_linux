class Pure < Formula
  desc "Pretty, minimal and fast ZSH prompt"
  homepage "https://github.com/sindresorhus/pure"
  url "https://github.com/sindresorhus/pure/archive/v1.16.0.tar.gz"
  sha256 "152ffa2cffb6b79e10b78c0fb1de0b8461bae87822439d10ea9c749836060eca"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "0fdaf19fad7766f7f2fecb0c5622c84d6098520b8d22115d6a3a591eba32134c"
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
