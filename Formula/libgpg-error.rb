class LibgpgError < Formula
  desc "Common error values for all GnuPG components"
  homepage "https://www.gnupg.org/related_software/libgpg-error/"
  url "https://gnupg.org/ftp/gcrypt/libgpg-error/libgpg-error-1.38.tar.bz2"
  sha256 "d8988275aa69d7149f931c10442e9e34c0242674249e171592b430ff7b3afd02"

  bottle do
    sha256 "23059fb82c2bd698184b74900bcca5e0623a334a1e91f440eeea800c9b56bb59" => :catalina
    sha256 "a00980a1b2d0fe037601aa29b18cd4a36fdfbd63724528a665c20527f39b0e4b" => :mojave
    sha256 "88ca7a9b43458356370ca1d6eb32cef1a57ea79f5275273a68ca3330e55cb67f" => :high_sierra
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--enable-static"
    system "make", "install"

    # avoid triggering mandatory rebuilds of software that hard-codes this path
    inreplace bin/"gpg-error-config", prefix, opt_prefix
  end

  test do
    system "#{bin}/gpg-error-config", "--libs"
  end
end
