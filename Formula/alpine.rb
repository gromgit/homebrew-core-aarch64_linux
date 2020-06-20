class Alpine < Formula
  desc "News and email agent"
  homepage "http://alpine.x10host.com/alpine/release/"
  url "http://alpine.x10host.com/alpine/release/src/alpine-2.23.tar.xz"
  sha256 "793a61215c005b5fcffb48f642f125915276b7ec7827508dd9e83d4c4da91f7b"
  head "https://repo.or.cz/alpine.git"

  bottle do
    sha256 "d9f2c103746223a50f9bd17cc113e33b058a801a9c69f0cde9613f0120b6dc68" => :catalina
    sha256 "3061917e8f114d875869a3beb88da6c091a774dd657841052b97d054f10298f9" => :mojave
    sha256 "8d4a1d7a99103583a2b8e01639e2204b2d6c1c7e028c8d78ce39f82465ab3799" => :high_sierra
  end

  depends_on "openssl@1.1"

  uses_from_macos "ncurses"

  def install
    ENV.deparallelize

    args = %W[
      --disable-debug
      --with-ssl-dir=#{Formula["openssl@1.1"].opt_prefix}
      --with-ssl-certs-dir=#{etc}/openssl@1.1
      --prefix=#{prefix}
      --with-bundled-tools
    ]

    system "./configure", *args
    system "make", "install"
  end

  test do
    system "#{bin}/alpine", "-conf"
  end
end
