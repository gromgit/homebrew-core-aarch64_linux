class Mint < Formula
  desc "Dependency manager that installs and runs Swift command-line tool packages"
  homepage "https://github.com/yonaskolb/Mint"
  url "https://github.com/yonaskolb/Mint/archive/0.16.0.tar.gz"
  sha256 "bbd258ba5e79da579b0d0526c55c5141382df638a1fb139e02fa92a66b608be4"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "cbcbebc4beb6ce7b39d7a7518154b63ea5496cfd69089f912eedb75c93b60423" => :big_sur
    sha256 "cc7a17ee517fe97f12852c71252896c9ca30dfe8236f816f2990b2d0553ff5b3" => :catalina
    sha256 "f70e96558839243a845c67f15defbd8718ad5a9e094ae1c1b998ac9faf4399b0" => :mojave
  end

  depends_on xcode: ["12.0", :build]

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
