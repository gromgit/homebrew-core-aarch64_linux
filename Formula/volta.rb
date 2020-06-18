class Volta < Formula
  desc "JavaScript toolchain manager for reproducible environments"
  homepage "https://volta.sh"
  url "https://github.com/volta-cli/volta.git",
    :revision => "bb0eb6a80a7aaa04aa7fe038c7f824a535933fe9",
    :tag      => "v0.8.2"

  bottle do
    cellar :any_skip_relocation
    sha256 "d6d8f99bba79a84e35d18613882319e461331335b9ba4cd9488e9ed20e2126fa" => :catalina
    sha256 "d6a3e143d962b4f568b9622212a8adcbf6e37b5ab087c60e4114fdbbac27d512" => :mojave
    sha256 "e3ac03ef6031010ecd7038e593bcb761e7947edd5b2538080073a75e89b281fc" => :high_sierra
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--locked", "--root", prefix, "--path", "."
  end

  test do
    system "#{bin}/volta", "install", "node@12.16.1"
    node = shell_output("#{bin}/volta which node").chomp
    assert_match "12.16.1", shell_output("#{node} --version")
  end
end
