class Dex < Formula
  desc "Dextrous text editor"
  homepage "https://github.com/tihirvon/dex"
  url "https://github.com/tihirvon/dex/archive/v1.0.tar.gz"
  sha256 "4468b53debe8da6391186dccb78288a8a77798cb4c0a00fab9a7cdc711cd2123"
  license "GPL-2.0-only"
  head "https://github.com/tihirvon/dex.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/dex"
    sha256 aarch64_linux: "d803b21a299c8e550a6aed2c76049350e9510c86b23f7803e5ba12b4be8be8d1"
  end

  uses_from_macos "ncurses"

  def install
    args = ["prefix=#{prefix}",
            "CC=#{ENV.cc}",
            "HOST_CC=#{ENV.cc}"]

    args << "VERSION=#{version}" if build.head?

    system "make", "install", *args
  end

  test do
    system bin/"dex", "-V"
  end
end
