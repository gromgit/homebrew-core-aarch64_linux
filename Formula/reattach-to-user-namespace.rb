class ReattachToUserNamespace < Formula
  desc "Reattach process (e.g., tmux) to background"
  homepage "https://github.com/ChrisJohnsen/tmux-MacOSX-pasteboard"
  url "https://github.com/ChrisJohnsen/tmux-MacOSX-pasteboard/archive/v2.9.tar.gz"
  sha256 "e4df00ead6b267a027a4ea35032bcfa114d91e709b1986ec0cbaee6825cec436"
  license "BSD-2-Clause"
  head "https://github.com/ChrisJohnsen/tmux-MacOSX-pasteboard.git", branch: "master"

  depends_on :macos

  def install
    system "make"
    bin.install "reattach-to-user-namespace"
  end

  test do
    system bin/"reattach-to-user-namespace", "-l", "bash", "-c", "echo Hello World!"
  end
end
