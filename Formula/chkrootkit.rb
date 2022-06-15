class Chkrootkit < Formula
  desc "Rootkit detector"
  homepage "http://www.chkrootkit.org/"
  url "ftp://ftp.pangeia.com.br/pub/seg/pac/chkrootkit-0.55.tar.gz"
  mirror "https://fossies.org/linux/misc/chkrootkit-0.55.tar.gz"
  sha256 "a81c0286ec449313f953701202a00e81b204fc2cf43e278585a11c12a5e0258b"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?download[^>]*>chkrootkit v?(\d+(?:\.\d+)+)/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/chkrootkit"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "e2ed9789bc78ef75c6293b7d048c6190d45ef59ce4f0794d963e0fc955e06a1b"
  end

  def install
    system "make", "CC=#{ENV.cc}", "CFLAGS=#{ENV.cflags}",
                   "STATIC=", "sense", "all"

    bin.install Dir[buildpath/"*"].select { |f| File.executable? f }
    doc.install %w[README README.chklastlog README.chkwtmp]
  end

  test do
    assert_equal "chkrootkit version #{version}",
                 shell_output("#{bin}/chkrootkit -V 2>&1", 1).strip
  end
end
