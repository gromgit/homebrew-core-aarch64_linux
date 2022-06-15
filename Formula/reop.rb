class Reop < Formula
  desc "Encrypted keypair management"
  homepage "https://flak.tedunangst.com/post/reop"
  url "https://flak.tedunangst.com/files/reop-2.1.1.tgz"
  mirror "https://bo.mirror.garr.it/OpenBSD/distfiles/reop-2.1.1.tgz"
  sha256 "fa8ae058c51efec5bde39fab15b4275e6394d9ab1dd2190ffdba3cf9983fdcac"

  livecheck do
    skip "No longer developed"
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/reop"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "cd8992a740dd5bc232174b271ef5d2ccefbf68e196c3cd8b5198aa63af47c06a"
  end

  depends_on "libsodium"

  def install
    system "make", "-f", "GNUmakefile"
    bin.install "reop"
    man1.install "reop.1"
  end

  test do
    (testpath/"pubkey").write <<~EOS
      -----BEGIN REOP PUBLIC KEY-----
      ident:root
      RWRDUxZNDeX4wcynGeCr9Bro6Ic7s1iqi1XHYacEaHoy+7jOP+ZE0yxR+2sfaph2MW15e8eUZvvI
      +lxZaqFZR6Kc4uVJnvirIK97IQ==
      -----END REOP PUBLIC KEY-----
    EOS

    (testpath/"msg").write <<~EOS
      testing one two three four
    EOS

    (testpath/"sig").write <<~EOS
      -----BEGIN REOP SIGNATURE-----
      ident:root
      RWQWTQ3l+MHMpx8RO/+BX/xxHn0PiSneiJ1Au2GurAmx4L942nZFBRDOVw2xLzvp/RggTVTZ46k+
      GLVjoS6fSuLneCfaoRlYHgk=
      -----END REOP SIGNATURE-----
    EOS

    system "#{bin}/reop", "-V", "-x", "sig", "-p", "pubkey", "-m", "msg"
  end
end
