class Liquidprompt < Formula
  desc "Adaptive prompt for bash and zsh shells"
  homepage "https://github.com/nojhan/liquidprompt"
  url "https://github.com/nojhan/liquidprompt/archive/v2.1.2.tar.gz"
  sha256 "f752f46595519befd1ad83eaa3605cfc05babd485250a0b46916d8eacabf4f26"
  license "AGPL-3.0-or-later"
  head "https://github.com/nojhan/liquidprompt.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/liquidprompt"
    sha256 cellar: :any_skip_relocation, x86_64_aarch64_linux: "85b6c43ad094ce516ea27402ef069af47630a9a3b8eb540e46554a40a8481952"
  end

  def install
    share.install "liquidpromptrc-dist"
    share.install "liquidprompt"
  end

  def caveats
    <<~EOS
      Add the following lines to your bash or zsh config (e.g. ~/.bash_profile):
        if [ -f #{HOMEBREW_PREFIX}/share/liquidprompt ]; then
          . #{HOMEBREW_PREFIX}/share/liquidprompt
        fi

      If you'd like to reconfigure options, you may do so in ~/.liquidpromptrc.
      A sample file you may copy and modify has been installed to
        #{HOMEBREW_PREFIX}/share/liquidpromptrc-dist
    EOS
  end

  test do
    liquidprompt = "#{HOMEBREW_PREFIX}/share/liquidprompt"
    output = shell_output("/bin/bash -c '. #{liquidprompt} --no-activate; lp_theme --list'")
    assert_match "default\n", output
  end
end
