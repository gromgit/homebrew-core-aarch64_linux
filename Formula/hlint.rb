require "language/haskell"

class Hlint < Formula
  include Language::Haskell::Cabal

  desc "Haskell source code suggestions"
  homepage "https://github.com/ndmitchell/hlint"
  url "https://hackage.haskell.org/package/hlint-3.1.4/hlint-3.1.4.tar.gz"
  sha256 "bbe132ae5e2a7428e6c5a53bbb224809163996d024bb260aebc66d6637b050f3"
  head "https://github.com/ndmitchell/hlint.git"

  bottle do
    sha256 "629985b60faceb73069e5c3a89d35116a06efcb6d538149667bb10352ecfcd2f" => :catalina
    sha256 "6eb29d15f8c9cecd0c4c7a8a3b121f2cdc8702d1bda4647f4e1c7ea661c0f32e" => :mojave
    sha256 "ec62403f899c3d1c6c1174aa17f893644c06d1a7e304f568e6328cad15bd8ac5" => :high_sierra
  end

  depends_on "cabal-install" => :build
  depends_on "ghc@8.8" => :build

  uses_from_macos "ncurses"

  def install
    install_cabal_package :using => ["alex", "happy"]
    man1.install "data/hlint.1"
  end

  test do
    (testpath/"test.hs").write <<~EOS
      main = do putStrLn "Hello World"
    EOS
    assert_match "No hints", shell_output("#{bin}/hlint test.hs")

    (testpath/"test1.hs").write <<~EOS
      main = do foo x; return 3; bar z
    EOS
    assert_match "Redundant return", shell_output("#{bin}/hlint test1.hs", 1)
  end
end
