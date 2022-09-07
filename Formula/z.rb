class Z < Formula
  desc "Tracks most-used directories to make cd smarter"
  homepage "https://github.com/rupa/z"
  # Please don't update this formula to 1.11.
  # https://github.com/rupa/z/issues/205
  url "https://github.com/rupa/z/archive/v1.9.tar.gz"
  sha256 "e2860e4f65770e02297ca4ca08ec1ee623a658bd9cc1acddbbe5ad22e1de70a7"
  license "WTFPL"
  version_scheme 1
  head "https://github.com/rupa/z.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/z"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "c41e34d081b40057fcc4c2cfd9616dab9b36159f609a14c877e9580249e63e9b"
  end

  def install
    (prefix/"etc/profile.d").install "z.sh"
    man1.install "z.1"
  end

  def caveats
    <<~EOS
      For Bash or Zsh, put something like this in your $HOME/.bashrc or $HOME/.zshrc:
        . #{etc}/profile.d/z.sh
    EOS
  end

  test do
    (testpath/"zindex").write("/usr/local|1|1491427986\n")
    testcmd = "/bin/bash -c '_Z_DATA=#{testpath}/zindex; . #{etc}/profile.d/z.sh; _z -l 2>&1'"
    assert_match "/usr/local", pipe_output(testcmd)
  end
end
