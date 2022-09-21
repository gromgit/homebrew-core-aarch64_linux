class Dstask < Formula
  desc "Git-powered personal task tracker"
  homepage "https://github.com/naggie/dstask"
  url "https://github.com/naggie/dstask/archive/v0.25.tar.gz"
  sha256 "7a8b4e9d2d3ce6a59551fa181201148a008c35505d43593f80b1fe80493fdb8c"
  license "MIT"
  head "https://github.com/naggie/dstask.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/dstask"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "bd016ae445c2e666b45b8e405c19863db9d3fde0f9dabbcfea7ce642749d88b0"
  end

  depends_on "go" => :build

  def install
    system "go", "mod", "vendor"
    system "make", "dist/dstask"
    bin.install Dir["dist/*"]
  end

  test do
    mkdir ".dstask" do
      system "git", "init"
      system "git", "config", "user.name", "BrewTestBot"
      system "git", "config", "user.email", "BrewTestBot@test.com"
    end

    system bin/"dstask", "add", "Brew the brew"
    system bin/"dstask", "start", "1"
    output = shell_output("#{bin}/dstask show-active")
    assert_match "Brew the brew", output
    system bin/"dstask", "done", "1"
  end
end
