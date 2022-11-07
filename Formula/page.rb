class Page < Formula
  desc "Use Neovim as pager"
  homepage "https://github.com/I60R/page"
  url "https://github.com/I60R/page/archive/v3.1.2.tar.gz"
  sha256 "18089dd86dbbf3b02d8b85412e76f9881a8e2cd957e7201dbbb2b8d71dd5074a"
  license "MIT"
  head "https://github.com/I60R/page.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/page"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "889a59e4d8cc9c185d01ba07f85d09753b302e5e043edaf676411aefeb40c7dd"
  end

  depends_on "rust" => :build
  depends_on "neovim"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    text = "test"
    assert_match text, pipe_output("#{bin}/page -O 1", text)
  end
end
