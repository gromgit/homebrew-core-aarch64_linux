class Nsd < Formula
  desc "Name server daemon"
  homepage "https://www.nlnetlabs.nl/projects/nsd/"
  url "https://www.nlnetlabs.nl/downloads/nsd/nsd-4.3.8.tar.gz"
  sha256 "11897e25f72f5a98f9202bd5378c936886d54376051a614d3688e451e9cb99e1"
  license "BSD-3-Clause"

  # We check the GitHub repo tags instead of
  # https://www.nlnetlabs.nl/downloads/nsd/ since the first-party site has a
  # tendency to lead to an `execution expired` error.
  livecheck do
    url "https://github.com/NLnetLabs/nsd.git"
    regex(/^NSD[._-]v?(\d+(?:[._]\d+)+)[._-]REL$/i)
  end

  bottle do
    sha256 arm64_big_sur: "1e0473c4f7aa04a657fc961695785f3141e096a9492a0325325aa913384eaeb8"
    sha256 big_sur:       "d47418395b19b1d079cc1c15dbb0984dbc8c9e0dfcd2d4003f571c0dfaa6702d"
    sha256 catalina:      "af75943145733afcb9d40b08ac04f3f27387ec5ecbd9feb642f659d688269f39"
    sha256 mojave:        "c443e9e09186eca5e52e7fe24847913de0f2faa21d83f44ffb47f50ef2a974f9"
    sha256 x86_64_linux:  "831286168eae3f0c4d3c2ec18cbfd4b962b593fc5ce03664d8bce614a62768c2"
  end

  depends_on "libevent"
  depends_on "openssl@1.1"

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--sysconfdir=#{etc}",
                          "--localstatedir=#{var}",
                          "--with-libevent=#{Formula["libevent"].opt_prefix}",
                          "--with-ssl=#{Formula["openssl@1.1"].opt_prefix}"
    system "make", "install"
  end

  test do
    system "#{sbin}/nsd", "-v"
  end
end
