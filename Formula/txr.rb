class Txr < Formula
  desc "Original, new programming language for convenient data munging"
  homepage "https://www.nongnu.org/txr/"
  url "http://www.kylheku.com/cgit/txr/snapshot/txr-234.tar.bz2"
  sha256 "d29cd9b3773e3639398b5fa13d9609be4492a44947cfdd6b6dc58fa721bdf4e8"
  head "http://www.kylheku.com/git/txr", :using => :git

  bottle do
    cellar :any_skip_relocation
    sha256 "75e3da843c36098dffaa3bd6f5da3aa4c16245a8a3a88a896f39a690077c04aa" => :catalina
    sha256 "7d2d43005b9c738b372e19fa5f57727c97317635e96521932093d0ebd7e66edf" => :mojave
    sha256 "48bcb460f3e6f13c75b9afd1edac3f1e5085f5905772018061ebf8a1f321827d" => :high_sierra
  end

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    assert_equal "3", shell_output(bin/"txr -p '(+ 1 2)'").chomp
  end
end
