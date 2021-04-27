class ZshViMode < Formula
  desc "Better and friendly vi(vim) mode plugin for ZSH"
  homepage "https://github.com/jeffreytse/zsh-vi-mode"
  url "https://github.com/jeffreytse/zsh-vi-mode/archive/refs/tags/v0.8.2.tar.gz"
  sha256 "888d68b451fc3221c2ee1648dbfbff38e524048b2c78620a244650fc76946c28"
  license "MIT"
  head "https://github.com/jeffreytse/zsh-vi-mode.git"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "4ef061c362f1a957cb1ffb3bbf50763e34d1751ce9e46dca30bfeabc6e3f21ce"
  end

  def install
    pkgshare.install "zsh-vi-mode.zsh"
    pkgshare.install "zsh-vi-mode.plugin.zsh"
  end

  def caveats
    <<~EOS
      To activate the zsh vi mode, add the following line to your .zshrc:
        source #{opt_pkgshare}/zsh-vi-mode.plugin.zsh
    EOS
  end

  test do
    assert_match "zsh-vi-mode",
      shell_output("zsh -c '. #{pkgshare}/zsh-vi-mode.plugin.zsh && zvm_version'")
  end
end
