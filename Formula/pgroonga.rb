class Pgroonga < Formula
  desc "PostgreSQL plugin to use Groonga as index"
  homepage "https://pgroonga.github.io/"
  url "https://packages.groonga.org/source/pgroonga/pgroonga-2.2.9.tar.gz"
  sha256 "f65978fa843cb1a5fb82e72531b88fae481e428930163c06a281e02c0140e3b7"
  license "PostgreSQL"

  livecheck do
    url "https://packages.groonga.org/source/pgroonga/"
    regex(/href=.*?pgroonga[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "488119d71f44926797d38b6e69cfa00b2d10d1cfcb390166516d99bfba933091"
    sha256 cellar: :any, big_sur:       "58f39a403151e4110941062db18220b0d15f8de6377c178bf3aaeda39e9f686a"
    sha256 cellar: :any, catalina:      "1e6749eae1974a8216f6f8564fe7cf79d0bb85e57f76e4c773acd741308f6a17"
    sha256 cellar: :any, mojave:        "c5c37e09d2fa0a7b202be2a9f0bccc35c5d51965d2c9db53257d5d654ad3fae6"
  end

  depends_on "pkg-config" => :build
  depends_on "groonga"
  depends_on "postgresql"

  def install
    system "make"
    mkdir "stage"
    system "make", "install", "DESTDIR=#{buildpath}/stage"

    lib.install Dir["stage/**/lib/*"]
    (share/"postgresql/extension").install Dir["stage/**/share/postgresql/extension/*"]
  end
end
