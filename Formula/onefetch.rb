class Onefetch < Formula
  desc "Git repository summary on your terminal"
  homepage "https://github.com/o2sh/onefetch"
  url "https://github.com/o2sh/onefetch/archive/v2.7.3.tar.gz"
  sha256 "c0d8ccfe7addf6112737c0e4681c8a418580e234708c322aae329bc3ad10cf5b"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "2feadcb1d54d9b0a9121766ca7102908500f58438cb3b621cb2a0f6989eff8ab" => :big_sur
    sha256 "6644aa90d4efb85e61aa3eb5dc5ee07833b77f756de708ccae21c8f9134077ca" => :catalina
    sha256 "d6f3c70a938a8b7412c21fb3ba148c2b8726c960d3808f793e3d301b0d163ad3" => :mojave
  end

  depends_on "rust" => :build

  uses_from_macos "zlib"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system "#{bin}/onefetch", "--help"
    assert_match "onefetch " + version.to_s, shell_output("#{bin}/onefetch -V").chomp

    system "git init"
    system "git", "config", "user.name", "BrewTestBot"
    system "git", "config", "user.email", "BrewTestBot@test.com"
    system "echo \"puts 'Hello, world'\" > main.rb && git add main.rb && git commit -m \"First commit\""
    assert_match /Language:.*Ruby/, shell_output("#{bin}/onefetch").chomp
  end
end
