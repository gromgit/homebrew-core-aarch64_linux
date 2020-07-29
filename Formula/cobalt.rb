class Cobalt < Formula
  desc "Static site generator written in Rust"
  homepage "https://cobalt-org.github.io/"
  url "https://github.com/cobalt-org/cobalt.rs/archive/v0.16.1.tar.gz"
  sha256 "b06240280b044d54051d5ed754a6bb39a0c2db5f0ecaecab53a41ab273ab35ac"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "68e940b5fdf57485168b0a773b409d01dabddd86914ca08d98ca4c323760a61a" => :catalina
    sha256 "579d08ee0cdb7b55ab3ec50d986221aa40dd2c583774cc8abc535dcd4031ecfa" => :mojave
    sha256 "1d30487108425b5fc7f5af86974ad97121a0c456843ab0693b737aa11f131bf0" => :high_sierra
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system bin/"cobalt", "init"
    system bin/"cobalt", "build"
    assert_predicate testpath/"_site/index.html", :exist?
  end
end
