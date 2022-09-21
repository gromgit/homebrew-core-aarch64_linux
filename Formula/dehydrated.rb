class Dehydrated < Formula
  desc "LetsEncrypt/acme client implemented as a shell-script"
  homepage "https://dehydrated.io"
  url "https://github.com/dehydrated-io/dehydrated/archive/v0.7.0.tar.gz"
  sha256 "1c5f12c2e57e64b1762803f82f0f7e767a72e65a6ce68e4d1ec197e61b9dc4f9"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/dehydrated"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "72aba0ea1f34de27cb8f34462ab87665609991697ffdd8a7d4322870085d9a45"
  end

  def install
    bin.install "dehydrated"
    man1.install "docs/man/dehydrated.1"
  end

  test do
    system bin/"dehydrated", "--help"
  end
end
