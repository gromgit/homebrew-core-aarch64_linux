class Iniparser < Formula
  desc "Library for parsing ini files"
  homepage "http://ndevilla.free.fr/iniparser/"
  url "https://github.com/ndevilla/iniparser/archive/v4.1.tar.gz"
  sha256 "960daa800dd31d70ba1bacf3ea2d22e8ddfc2906534bf328319495966443f3ae"
  license "MIT"
  head "https://github.com/ndevilla/iniparser.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/iniparser"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "f259fa30381d88ac8a3734f442815eb893a26c0e0ff7f0ca99343317eb2b965c"
  end

  conflicts_with "fastbit", because: "both install `include/dictionary.h`"

  def install
    # Only make the *.a file; the *.so target is useless (and fails).
    system "make", "libiniparser.a", "CC=#{ENV.cc}", "RANLIB=ranlib"
    lib.install "libiniparser.a"
    include.install Dir["src/*.h"]
  end
end
