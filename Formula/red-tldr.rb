class RedTldr < Formula
  desc "Used to help red team staff quickly find the commands and key points"
  homepage "https://payloads.online/red-tldr/"
  url "https://github.com/Rvn0xsy/red-tldr/archive/v0.4.3.tar.gz"
  sha256 "3f32a438226287d80ae86509964d7767c2002952c95da03501beb882cae22d2d"
  license "MIT"
  head "https://github.com/Rvn0xsy/red-tldr.git", branch: "main"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/red-tldr"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "d216ee5a98775c37841389827763605cec04abc33b5b9d1882f129c02c36deff"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match "privilege", shell_output("#{bin}/red-tldr mimikatz")
  end
end
