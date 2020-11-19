class Oxipng < Formula
  desc "Multithreaded PNG optimizer written in Rust"
  homepage "https://github.com/shssoichiro/oxipng"
  url "https://github.com/shssoichiro/oxipng/archive/v4.0.1.tar.gz"
  sha256 "c5684730757a49a55c3bac66de139da5a1fdcd190f8ea3b9a95e1fc8feccb106"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "6d64ae1d1ac76e5fefab707194a9e3507637a3802cdb99f9d2a5cb9445b2e83b" => :big_sur
    sha256 "8a526f4ed5017b9473701529d82f571d771201f75291f7d28e34ae2997369c2c" => :catalina
    sha256 "6f5a043137f073691026e73f2e78956339efb79645dfcc6cf8f4f1687c695a53" => :mojave
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system "#{bin}/oxipng", "--pretend", test_fixtures("test.png")
  end
end
