class Mint < Formula
  desc "Dependency manager that installs and runs Swift command-line tool packages"
  homepage "https://github.com/yonaskolb/Mint"
  url "https://github.com/yonaskolb/Mint/archive/0.14.1.tar.gz"
  sha256 "f6d1c67bab54d337ba2c1b2ab520bf1a4b24e47539d272cdf00a447b41ddd15c"

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
