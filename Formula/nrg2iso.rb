class Nrg2iso < Formula
  desc "Extract ISO9660 data from Nero nrg files"
  homepage "http://gregory.kokanosky.free.fr/v4/linux/nrg2iso.en.html"
  url "http://gregory.kokanosky.free.fr/v4/linux/nrg2iso-0.4.1.tar.gz"
  sha256 "3be36a416758fc1910473b49a8dadf2a2aa3d51f1976197336bc174bc1e306e5"
  license "GPL-3.0-or-later"

  # The latest version reported on the English page (nrg2iso.en.html) and the
  # main French page (nrg2iso.html) can differ, so we may want to keep an eye
  # on this to make sure we don't miss any versions.
  livecheck do
    url :homepage
    regex(/href=.*?nrg2iso[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/nrg2iso"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "a9d69de79594bbb59a89878b98b393fdd2772ea4fa9573fc1adadc9c18aad6d4"
  end

  def install
    # fix version output issue
    inreplace "nrg2iso.c", "VERSION \"0.4\"", "VERSION \"#{version}\""

    system "make"
    bin.install "nrg2iso"
  end

  test do
    assert_equal "nrg2iso v#{version}",
      shell_output("#{bin}/nrg2iso --version").chomp
  end
end
