class Pure < Formula
  desc "Pretty, minimal and fast ZSH prompt"
  homepage "https://github.com/sindresorhus/pure"
  url "https://github.com/sindresorhus/pure/archive/v1.20.3.tar.gz"
  sha256 "b26b1db80dac6fa0111941ff5f88a9264bab9f623f0bf949d67474d43ee8893e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "31103c767fec70824c92bfc6ff71edacd4f6bbdec87f0ce8cc467febcb2a6d51"
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
