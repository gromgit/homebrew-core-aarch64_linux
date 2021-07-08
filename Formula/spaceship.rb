class Spaceship < Formula
  desc "Zsh prompt for Astronauts"
  homepage "https://spaceship-prompt.sh"
  url "https://github.com/spaceship-prompt/spaceship-prompt/archive/v3.12.26.tar.gz"
  sha256 "86ddc49d901d54e6d2f5b1892c24e0679ff3d19e873b7395352e95857e196b36"
  license "MIT"
  head "https://github.com/spaceship-prompt/spaceship-prompt.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "bfd3ca6791e426f02926eabd809cbdfa228edaeb1e8bba8c8ff6c8c60a4fb01d"
    sha256 cellar: :any_skip_relocation, big_sur:       "bfd3ca6791e426f02926eabd809cbdfa228edaeb1e8bba8c8ff6c8c60a4fb01d"
    sha256 cellar: :any_skip_relocation, catalina:      "bfd3ca6791e426f02926eabd809cbdfa228edaeb1e8bba8c8ff6c8c60a4fb01d"
    sha256 cellar: :any_skip_relocation, mojave:        "bfd3ca6791e426f02926eabd809cbdfa228edaeb1e8bba8c8ff6c8c60a4fb01d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "37256808f73d7d22ff41a440c8c8f454fc89e4dd1d3a68ffcfa78eca20645429"
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
