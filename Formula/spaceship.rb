class Spaceship < Formula
  desc "Zsh prompt for Astronauts"
  homepage "https://denysdovhan.com/spaceship-prompt"
  url "https://github.com/denysdovhan/spaceship-prompt/archive/v3.12.1.tar.gz"
  sha256 "fd8731f663d9c207f5c89927e3a8e1fa7c66f500681ac0e77bbf20d155987624"
  license "MIT"
  head "https://github.com/denysdovhan/spaceship-prompt.git"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "76be28658fcf856ab1833d76625a7131edb8bfff7a47acbc793fa588ef5cf453"
  end

  depends_on "zsh" => :test

  def install
    libexec.install "spaceship.zsh", "lib", "sections"
    zsh_function.install_symlink libexec/"spaceship.zsh" => "prompt_spaceship_setup"
  end

  test do
    ENV["SPACESHIP_CHAR_SYMBOL"] = "🍺"
    prompt = "setopt prompt_subst; autoload -U promptinit; promptinit && prompt -p spaceship"
    assert_match ENV["SPACESHIP_CHAR_SYMBOL"], shell_output("zsh -c '#{prompt}'")
  end
end
