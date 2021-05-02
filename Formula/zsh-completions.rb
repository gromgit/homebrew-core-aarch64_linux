class ZshCompletions < Formula
  desc "Additional completion definitions for zsh"
  homepage "https://github.com/zsh-users/zsh-completions"
  url "https://github.com/zsh-users/zsh-completions/archive/0.32.0.tar.gz"
  sha256 "d2d20836fb60d2e5de11b08f1a8373484dc01260d224e64c6de9eec44137fa63"
  license "MIT-Modern-Variant"
  revision 1
  head "https://github.com/zsh-users/zsh-completions.git"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "8a580890a89c20941f937941151eed3b638bbbbf86a202332514445b9f25f7eb"
  end

  def install
    inreplace "src/_ghc", "/usr/local", HOMEBREW_PREFIX
    zsh_completion.install Dir["src/*"]
  end

  def caveats
    <<~EOS
      To activate these completions, add the following to your .zshrc:

        autoload -Uz compinit
        compinit

      You may also need to force rebuild `zcompdump`:

        rm -f ~/.zcompdump; compinit

      Additionally, if you receive "zsh compinit: insecure directories" warnings when attempting
      to load these completions, you may need to run this:

        chmod -R go-w '#{HOMEBREW_PREFIX}/share/zsh'
    EOS
  end

  test do
    (testpath/"test.zsh").write <<~EOS
      autoload _ack
      which _ack
    EOS
    assert_match(/^_ack/, shell_output("/bin/zsh -fd test.zsh"))
  end
end
