class Lazygit < Formula
  desc "Simple terminal UI for git commands"
  homepage "https://github.com/jesseduffield/lazygit/"
  url "https://github.com/jesseduffield/lazygit/archive/v0.23.5.tar.gz"
  sha256 "947072ae2f83b52747adae99988e5159d629bb449962612efdf0ad6daad67688"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "fa33eed7fdb063b4acdcada5ab7f4b9778976a7e8e8f4841083b701d3121c5c0" => :catalina
    sha256 "b2af1741151d2a110b37e1db518f796e4d483b52ddc9dda4041131a48e2b45aa" => :mojave
    sha256 "9a5cdb2d8effe9fe027ca9b6247f592846ec3285f288e1c0bd871b441c66ed50" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-mod=vendor", "-o", bin/"lazygit",
      "-ldflags", "-X main.version=#{version} -X main.buildSource=homebrew"
  end

  # lazygit is a terminal GUI, but it can be run in 'client mode' for example to write to git's todo file
  test do
    (testpath/"git-rebase-todo").write ""
    ENV["LAZYGIT_CLIENT_COMMAND"] = "INTERACTIVE_REBASE"
    ENV["LAZYGIT_REBASE_TODO"] = "foo"
    system "#{bin}/lazygit", "git-rebase-todo"
    assert_match "foo", (testpath/"git-rebase-todo").read
  end
end
