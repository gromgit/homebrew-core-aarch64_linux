class Eprover < Formula
  desc "Theorem prover for full first-order logic with equality"
  homepage "https://eprover.org/"
  url "https://wwwlehre.dhbw-stuttgart.de/~sschulz/WORK/E_DOWNLOAD/V_2.5/E.tgz"
  sha256 "8a53dfb7276c10794c3ce98527cfcf977939769e7a5e6dc2eda9b38be3fc404a"
  license any_of: ["GPL-2.0-or-later", "LGPL-2.1-or-later"]
  revision 1

  livecheck do
    url "https://wwwlehre.dhbw-stuttgart.de/~sschulz/WORK/E_DOWNLOAD/"
    regex(%r{href=.*?V?[._-]?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, catalina:    "224dffbf0f507dd756b45f8ab9f06ec65e963ecfeeea69dcf72e76cc95bf760d"
    sha256 cellar: :any_skip_relocation, mojave:      "598fb6477f28822a593fe6c0fb218b4e70140ba44f6cd21feb6c0381c0b64641"
    sha256 cellar: :any_skip_relocation, high_sierra: "9b2ece8fa609748d06a102d398c7315ab09c0da9af2d8b17daff11cb634767f6"
  end

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--man-prefix=#{man1}"
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/eprover", "--help"
  end
end
