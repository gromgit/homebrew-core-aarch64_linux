require "language/haskell"

class Pandoc < Formula
  include Language::Haskell::Cabal

  desc "Swiss-army knife of markup format conversion"
  homepage "https://pandoc.org/"
  url "https://hackage.haskell.org/package/pandoc-2.9.1.1/pandoc-2.9.1.1.tar.gz"
  sha256 "9d21c5efe2074f9b3097a20e0798de9d8b89a86a1ce04a307f476c7b4aa3816d"
  revision 1
  head "https://github.com/jgm/pandoc.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "55e06c473beb42777556120daee1e6762b7e107a3960ccfe03d7aa945530ff56" => :catalina
    sha256 "8c61ffb355a6fe34b6c78a669dfc94f3eec0a23ce00432285aaed0cf3ec89df7" => :mojave
    sha256 "916645db672c6cb63ce8e8c706e31ca110346f362bfbfde78063c906af148c68" => :high_sierra
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build

  def install
    cabal_sandbox do
      install_cabal_package :flags => ["embed_data_files"]
    end
    (bash_completion/"pandoc").write `#{bin}/pandoc --bash-completion`
    man1.install "man/pandoc.1"
  end

  test do
    input_markdown = <<~EOS
      # Homebrew

      A package manager for humans. Cats should take a look at Tigerbrew.
    EOS
    expected_html = <<~EOS
      <h1 id="homebrew">Homebrew</h1>
      <p>A package manager for humans. Cats should take a look at Tigerbrew.</p>
    EOS
    assert_equal expected_html, pipe_output("#{bin}/pandoc -f markdown -t html5", input_markdown)
  end
end
