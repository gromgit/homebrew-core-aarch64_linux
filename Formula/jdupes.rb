class Jdupes < Formula
  desc "Duplicate file finder and an enhanced fork of 'fdupes'"
  homepage "https://github.com/jbruchon/jdupes"
  url "https://github.com/jbruchon/jdupes/archive/v1.18.1.tar.gz"
  sha256 "94b4822af20e632130c0ad75ba6183ab8009c4920718cf951805f5a49fe07954"

  bottle do
    cellar :any_skip_relocation
    sha256 "da7bc84d87ece56b7892c5a4f37cb0e1e655101958d2976ecb4670b262408f60" => :catalina
    sha256 "985df42db7e61d0fc3b5fcb4228b0de86bbdebeddfb716e996c552d87ac83d7e" => :mojave
    sha256 "9d7f49fb217514118c62e3437960955a6ce1acc3925a2cdb561f2861a0355545" => :high_sierra
  end

  def install
    system "make", "install", "PREFIX=#{prefix}", "ENABLE_DEDUPE=1"
  end

  test do
    touch "a"
    touch "b"
    (testpath/"c").write("unique file")
    dupes = shell_output("#{bin}/jdupes --zeromatch .").strip.split("\n").sort
    assert_equal ["./a", "./b"], dupes
  end
end
