class Clockywock < Formula
  desc "Ncurses analog clock"
  homepage "https://web.archive.org/web/20210519013044/https://soomka.com/"
  url "https://web.archive.org/web/20160401181746/https://soomka.com/clockywock-0.3.1a.tar.gz"
  mirror "https://mirrors.kernel.org/gentoo/distfiles/11/clockywock-0.3.1a.tar.gz"
  sha256 "278c01e0adf650b21878e593b84b3594b21b296d601ee0f73330126715a4cce4"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/clockywock"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "302eae2cb82706ff3e1093c549facef3195b5b5f57d8cfaf28af9a02059f5d6f"
  end

  deprecate! date: "2022-03-30", because: :unmaintained

  uses_from_macos "ncurses"

  def install
    system "make"
    bin.install "clockywock"
    man7.install "clockywock.7"
  end

  test do
    system "#{bin}/clockywock", "-h"
  end
end
