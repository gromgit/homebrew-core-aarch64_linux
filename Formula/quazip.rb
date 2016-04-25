class Quazip < Formula
  desc "C++ wrapper over Gilles Vollant's ZIP/UNZIP package"
  homepage "http://quazip.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/quazip/quazip/0.7.2/quazip-0.7.2.tar.gz"
  sha256 "91d827fbcafd099ae814cc18a8dd3bb709da6b8a27c918ee1c6c03b3f29440f4"

  bottle do
    cellar :any
    sha256 "7e4cdb5d97b70dd67092965b00de2981adbcee229a7b00788cce11ebc7fb72d6" => :el_capitan
    sha256 "d15a12c624d377bd818458635ad078782659f313c223836f1689ed89cca32a63" => :yosemite
    sha256 "d6ea39c00ad991be78e2b6fdd1d69a5c4079fc85ef6dbdbedab7c8becf77d0c7" => :mavericks
    sha256 "a6a988cb89a12f6e7c2d5bd8ebe180f40b18f586f3bd1e09a6b881350daee637" => :mountain_lion
  end

  depends_on "qt"

  def install
    # On Mavericks we want to target libc++, this requires a unsupported/macx-clang-libc++ flag
    if ENV.compiler == :clang && MacOS.version >= :mavericks
      spec = "unsupported/macx-clang-libc++"
    else
      spec = "macx-g++"
    end

    args = %W[
      -config release
      -spec #{spec}
      PREFIX=#{prefix}
      LIBS+=-lz
    ]

    system "qmake", "quazip.pro", *args
    system "make", "install"

    cd "qztest" do
      args = %W[-config release -spec #{spec}]
      system "qmake", *args
      system "make"
      bin.install "qztest"
    end
  end

  test do
    system "#{bin}/qztest"
  end
end
