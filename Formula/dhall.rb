class Dhall < Formula
  desc "Interpreter for the Dhall language"
  homepage "https://dhall-lang.org/"
  url "https://hackage.haskell.org/package/dhall-1.37.0/dhall-1.37.0.tar.gz"
  sha256 "1d602b52c5e7c15411518a48cc22f0895226dd1ce77118eb0a6e968ab448c088"
  license "BSD-3-Clause"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "45f8d722eb741e0eef81f3130f4543f4fa56deb4180cc105bcd1e2cef9fdf6fe" => :big_sur
    sha256 "1814c3e3866124f46f6224c9ba7dcc8b907d9cf606a900a6084334012313cb87" => :catalina
    sha256 "fb55a1503ee8911880653c3ffdffe4b84f5801722735669774dad7ab44510b27" => :mojave
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build

  def install
    system "cabal", "v2-update"
    system "cabal", "v2-install", *std_cabal_v2_args
  end

  test do
    assert_match "{=}", pipe_output("#{bin}/dhall format", "{ = }", 0)
    assert_match "8", pipe_output("#{bin}/dhall normalize", "(\\(x : Natural) -> x + 3) 5", 0)
    assert_match "∀(x : Natural) → Natural", pipe_output("#{bin}/dhall type", "\\(x: Natural) -> x + 3", 0)
  end
end
