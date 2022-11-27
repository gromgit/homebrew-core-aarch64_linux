class ExVi < Formula
  desc "UTF8-friendly version of tradition vi"
  homepage "https://ex-vi.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/ex-vi/ex-vi/050325/ex-050325.tar.bz2"
  sha256 "da4be7cf67e94572463b19e56850aa36dc4e39eb0d933d3688fe8574bb632409"

  livecheck do
    url :stable
    regex(%r{url=.*?/ex[._-]v?(\d+(?:\.\d+)*)\.t}i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/ex-vi"
    sha256 aarch64_linux: "cefe7a4ad6b030418a9b5685a7e2c5ee3666f76d1a974aa373c8c7302e5ae501"
  end

  uses_from_macos "ncurses"

  conflicts_with "vim",
    because: "ex-vi and vim both install bin/ex and bin/view"

  def install
    system "make", "install", "INSTALL=/usr/bin/install",
                              "PREFIX=#{prefix}",
                              "PRESERVEDIR=/var/tmp/vi.recover",
                              "TERMLIB=ncurses"
  end
end
