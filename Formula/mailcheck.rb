class Mailcheck < Formula
  desc "Check multiple mailboxes/maildirs for mail"
  homepage "https://mailcheck.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/mailcheck/mailcheck/1.91.2/mailcheck_1.91.2.tar.gz"
  sha256 "6ca6da5c9f8cc2361d4b64226c7d9486ff0962602c321fc85b724babbbfa0a5c"
  license "GPL-2.0"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/mailcheck"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "12fcb29baaa17b777afe3a2f43a1e16dcbb9b43a77c90911b3da3ea40b3bb86a"
  end

  def install
    system "make", "mailcheck"
    bin.install "mailcheck"
    man1.install "mailcheck.1"
    etc.install "mailcheckrc"
  end
end
