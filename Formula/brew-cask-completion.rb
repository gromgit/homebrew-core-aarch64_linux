class BrewCaskCompletion < Formula
  desc "Fish completion for brew-cask"
  homepage "https://github.com/xyb/homebrew-cask-completion"
  url "https://github.com/xyb/homebrew-cask-completion/archive/v2.1.tar.gz"
  sha256 "27c7ea3b7f7c060f5b5676a419220c4ce6ebf384237e859a61c346f61c8f7a1b"
  license "BSD-2-Clause"
  revision 1
  head "https://github.com/xyb/homebrew-cask-completion.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/brew-cask-completion"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "e2871299df5a662a8bd34bc417a11920df0b6496bf48356e5e0c6227a4a99086"
  end

  def install
    fish_completion.install "brew-cask.fish"
  end

  test do
    assert_predicate fish_completion/"brew-cask.fish", :exist?
  end
end
