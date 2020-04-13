class Mint < Formula
  desc "Dependency manager that installs and runs Swift command-line tool packages"
  homepage "https://github.com/yonaskolb/Mint"
  url "https://github.com/yonaskolb/Mint/archive/0.14.2.tar.gz"
  sha256 "0ed7107159ee00fbc3f69b3325363406e868bdd0dd23ee50670eca8f14622ef5"

  bottle do
    cellar :any_skip_relocation
    sha256 "c904d521d18720a27a6eccdddd7747f2a680b7e9e87c309ebfc15c13b05e3def" => :catalina
    sha256 "449bdbdd101b36b678348588a372b9af7118bdbaa8ac73b826e4f86b706009fd" => :mojave
  end

  depends_on :xcode => ["10.2", :build]

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    # Test by showing the help scree
    system "#{bin}/mint", "help"
    # Test showing list of installed tools
    system "#{bin}/mint", "list"
  end
end
