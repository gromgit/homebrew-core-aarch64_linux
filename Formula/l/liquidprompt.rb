class Liquidprompt < Formula
  desc "Adaptive prompt for bash and zsh shells"
  homepage "https://liquidprompt.readthedocs.io/en/stable/"
  url "https://github.com/liquidprompt/liquidprompt/archive/refs/tags/v2.2.1.tar.gz"
  sha256 "56e9ee1c057638795eea31c7d91a81b8e0c4afd5b57c7dc3a5e3df98fd89b483"
  license "AGPL-3.0-or-later"
  head "https://github.com/liquidprompt/liquidprompt.git", branch: "master"

  bottle do
    root_url "https://github.com/homebrew/homebrew-core/releases/download/liquidprompt-2.2.1"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "d5e9f3eb6ed09c6742952d4cbace1805362823f68fab5faa98e32939215ea6bf"
  end

  def install
    share.install "liquidprompt"
  end

  def caveats
    <<~EOS
      Add the following lines to your bash or zsh config (e.g. ~/.bash_profile):
        if [ -f #{HOMEBREW_PREFIX}/share/liquidprompt ]; then
          . #{HOMEBREW_PREFIX}/share/liquidprompt
        fi

      If you'd like to reconfigure options, you may do so in ~/.liquidpromptrc.
    EOS
  end

  test do
    liquidprompt = "#{HOMEBREW_PREFIX}/share/liquidprompt"
    output = shell_output("/bin/bash -c '. #{liquidprompt} --no-activate; lp_theme --list'")
    assert_match "default\n", output
  end
end
