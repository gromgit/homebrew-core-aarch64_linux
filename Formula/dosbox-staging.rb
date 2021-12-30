class DosboxStaging < Formula
  desc "Modernized DOSBox soft-fork"
  homepage "https://dosbox-staging.github.io/"
  url "https://github.com/dosbox-staging/dosbox-staging/archive/v0.78.1.tar.gz"
  sha256 "9ae322edce853459fff47037fa4f7e3f138325699bf3c33d5335c069282133db"
  license "GPL-2.0-or-later"
  head "https://github.com/dosbox-staging/dosbox-staging.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_monterey: "f634764b7cefa11e450bcfe29dcecbb82d8125cc2cec86d22a10128a1ff74b19"
    sha256 cellar: :any, arm64_big_sur:  "6f4dc4d1961d8b03023989407c0f6e87a78e61717bc02dabeb5f5cc3c7c094a0"
    sha256 cellar: :any, monterey:       "ef7a5a75fe9a3832876bfba92fb436bfc901955e569e1b6834fb220579c6f361"
    sha256 cellar: :any, big_sur:        "d7f4608edc91ddc0e74dbff45251f6b8e8539fd4994dfa1326f2880c22b4f620"
    sha256 cellar: :any, catalina:       "8c21190904606a6cc0c6cf0e937cc3ef748298bb4982eb096443d3d1a928ab06"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "fluid-synth"
  depends_on "libpng"
  depends_on "libslirp"
  depends_on "mt32emu"
  depends_on "opusfile"
  depends_on "sdl2"
  depends_on "sdl2_net"

  def install
    mkdir "build" do
      system "meson", *std_meson_args, "-Db_lto=true", ".."
      system "ninja", "-v"
      system "ninja", "install", "-v"
    end
    mv bin/"dosbox", bin/"dosbox-staging"
    mv man1/"dosbox.1", man1/"dosbox-staging.1"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dosbox-staging -version")
    mkdir testpath/"Library/Preferences/DOSBox"
    touch testpath/"Library/Preferences/DOSBox/dosbox-staging.conf"
    output = shell_output("#{bin}/dosbox-staging -printconf")
    assert_equal "#{testpath}/Library/Preferences/DOSBox/dosbox-staging.conf", output.chomp
  end
end
