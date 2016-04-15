class Shakespeare < Formula
  desc "Write programs in Shakespearean English"
  homepage "http://shakespearelang.sourceforge.net/"
  url "http://shakespearelang.sf.net/download/spl-1.2.1.tar.gz"
  sha256 "1206ef0a2c853b8b40ca0c682bc9d9e0a157cc91a7bf4e28f19ccd003674b7d3"

  bottle do
    cellar :any_skip_relocation
    sha256 "03be6d4dcc0f3c6718f3c99eff2a469d78349d5842015823a57d1212ac675cd6" => :el_capitan
    sha256 "075eadd260c621c05ba7ffd8fc85d05f12355d4b90050b6285ee52c6c4fba43e" => :yosemite
    sha256 "307444fb92a5b99b57b4231ca3e6fc8892faf170b1aae15385971359492bcdab" => :mavericks
  end

  depends_on "flex" if MacOS.version >= :mountain_lion

  def install
    system "make", "install"
    bin.install "spl/bin/spl2c"
    include.install "spl/include/spl.h"
    lib.install "spl/lib/libspl.a"
  end
end
