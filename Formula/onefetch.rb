class Onefetch < Formula
  desc "Git repository summary on your terminal"
  homepage "https://github.com/o2sh/onefetch"
  url "https://github.com/o2sh/onefetch/archive/v2.7.2.tar.gz"
  sha256 "158126b087805d653ffdc9cceb7afcf6ff053e4285c7be5bc4be5a7bfe636524"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "03e3a7ae53dd7fb4bd1239af46f376c8730a95e9549878b36ff5406eafc81ba3" => :big_sur
    sha256 "3e3799c95b0b786908da99eb8d3dabd46547e495d3bf6d8c8309b6c9e211056e" => :catalina
    sha256 "66383f10ca62da313d5ebc7a55e70e01608dd3d56b43c9f3e910dca5e5a81e0b" => :mojave
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
