class DosboxStaging < Formula
  desc "Modernized DOSBox soft-fork"
  homepage "https://dosbox-staging.github.io/"
  url "https://github.com/dosbox-staging/dosbox-staging/archive/v0.79.0.tar.gz"
  sha256 "4c45dff631b6edbcec76f88be6e800b373d0303ef66189a6769a5a18fef106f2"
  license "GPL-2.0-or-later"
  head "https://github.com/dosbox-staging/dosbox-staging.git", branch: "main"

  # New releases of dosbox-staging are indicated by a GitHub release (and
  # an announcement on the homepage), not just a new version tag.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_monterey: "0ebe5b3c3213a23dcb4eae6b2bc7cac9ce9ad4e1fe70c840b02e3f72d6d72b49"
    sha256 cellar: :any, arm64_big_sur:  "52cab7703cfdc21afe3dca8a26ceadd6cfbb4636850728a9fc854ab6560b704b"
    sha256 cellar: :any, monterey:       "02018c8733f3d3b307b9388efed158883128652dc8a460dd28284ae441f34fae"
    sha256 cellar: :any, big_sur:        "b71c2f5a96aa2d6f6bf461b11e076279fba7eaf1c508e0792a6e39820a3686c8"
    sha256 cellar: :any, catalina:       "a266ceb73bd3fcd47d9963e863750545a439e73bc8363ed9f5e425c9a0b4b47e"
    sha256               x86_64_linux:   "f50fee225c7a21bf3beea92b134fa3c3571dc7fdd1a093e463f114439d346958"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "fluid-synth"
  depends_on "glib"
  depends_on "iir1"
  depends_on "libpng"
  depends_on "libslirp"
  depends_on "mt32emu"
  depends_on "opusfile"
  depends_on "sdl2"
  depends_on "sdl2_net"
  depends_on "speexdsp"
  uses_from_macos "zlib"

  on_linux do
    depends_on "mesa"
    depends_on "mesa-glu"
  end

  fails_with gcc: "5"

  def install
    (buildpath/"subprojects").rmtree # Ensure we don't use vendored dependencies
    system_libs = %w[fluidsynth glib iir mt32emu opusfile png sdl2 sdl2_net slirp speexdsp zlib]
    args = %W[-Ddefault_library=shared -Db_lto=true -Dtracy=false -Dsystem_libraries=#{system_libs.join(",")}]

    system "meson", "setup", "build", *args, *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"

    mv bin/"dosbox", bin/"dosbox-staging"
    mv man1/"dosbox.1", man1/"dosbox-staging.1"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dosbox-staging -version")
    config_path = OS.mac? ? "Library/Preferences/DOSBox" : ".config/dosbox"
    mkdir testpath/config_path
    touch testpath/config_path/"dosbox-staging.conf"
    output = shell_output("#{bin}/dosbox-staging -printconf")
    assert_equal testpath/config_path/"dosbox-staging.conf", Pathname(output.chomp)
  end
end
