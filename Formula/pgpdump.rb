class Pgpdump < Formula
  desc "PGP packet visualizer"
  homepage "https://www.mew.org/~kazu/proj/pgpdump/en/"
  url "https://github.com/kazu-yamamoto/pgpdump/archive/v0.35.tar.gz"
  sha256 "50b817d0ceaee41597b51e237e318803bf561ab6cf2dc1b49f68e85635fc8b0f"
  license "BSD-3-Clause"
  head "https://github.com/kazu-yamamoto/pgpdump.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/pgpdump"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "c101f301972057972fe24dec8eef2a5ac318688646f524a1b09a1f73064e2b3e"
  end

  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"sig.pgp").write <<~EOS
      -----BEGIN PGP MESSAGE-----
      Version: GnuPG v1.2.6 (NetBSD)
      Comment: For info see https://www.gnupg.org

      owGbwMvMwCSYq3dE6sEMJU7GNYZJLGmZOanWn4xaQzIyixWAKFEhN7W4ODE9VaEk
      XyEpVaE4Mz0vNUUhqVIhwD1Aj6vDnpmVAaQeZogg060chvkFjPMr2CZNmPnwyebF
      fJP+td+b6biAYb779N1eL3gcHUyNsjliW1ekbZk6wRwA
      =+jUx
      -----END PGP MESSAGE-----
    EOS

    output = shell_output("#{bin}/pgpdump sig.pgp")
    assert_match("Key ID - 0x6D2EC41AE0982209", output)
  end
end
