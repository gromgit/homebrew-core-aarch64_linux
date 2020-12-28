class TaskSpooler < Formula
  desc "Batch system to run tasks one after another"
  homepage "https://vicerveza.homeunix.net/~viric/soft/ts/"
  url "https://vicerveza.homeunix.net/~viric/soft/ts/ts-1.0.1.tar.gz"
  sha256 "f41ef307b0b9c7424398813b9c6e39d37a970831071e301842ba4b1145d56278"
  license "GPL-2.0-only"

  livecheck do
    url :homepage
    regex(/href=.*?ts[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "fd413989afe1cd32a45c02ed58b79dcab5c0242289a1b7ebf028228b4359aa39" => :arm64_big_sur
    sha256 "2a31687b430989e2a004ef2a3c69e20648707f6d60907031dcebd43b51924a38" => :catalina
    sha256 "319c29e750b0ba183b14accb571c4d210723458d5fcd72302b5ec866e5a76ad4" => :mojave
    sha256 "8045397e275ade52621a1ab3a21e3eddf277fafd1beea60db2d10bc15d11b8f2" => :high_sierra
    sha256 "e0f7e33946d3f8c93782692b3bab5833cb2e882f1fb47a4473b69e39ce3e7378" => :sierra
    sha256 "9403d0c240bad09d576288d6b5ed94057dad03ceb30a4893a935c13f9e58af7f" => :el_capitan
  end

  conflicts_with "moreutils", because: "both install a `ts` executable"

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system "#{bin}/ts", "-l"
  end
end
