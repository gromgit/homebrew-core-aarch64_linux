class DosboxX < Formula
  desc "DOSBox with accurate emulation and wide testing"
  homepage "https://dosbox-x.com/"
  url "https://github.com/joncampbell123/dosbox-x/archive/dosbox-x-v0.83.15.tar.gz"
  sha256 "06b9e0903e28841d21cd638d4a2133f4f90d8174c8b41c23767f7f0634efbee8"
  license "GPL-2.0-or-later"
  revision 1
  version_scheme 1
  head "https://github.com/joncampbell123/dosbox-x.git"

  livecheck do
    url :stable
    regex(/^dosbox-x[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "778f051f25408f6708ef8418167654efe99198e318bc3fd6fa2d0943bd8ba722"
    sha256 cellar: :any, big_sur:       "91e79ccc992500f4fdb146d012ceb5c8964644742b32b3c4657aefb668095e7f"
    sha256 cellar: :any, catalina:      "90b32c0659c11709710a8d6583953f6e90d0a24a86c83c253a260e01e93c4f22"
    sha256 cellar: :any, mojave:        "f7ba43612055f2ff47a43410876e2bded9b237507d545ca5a4b24853c90ae97b"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build
  depends_on "fluid-synth"
  depends_on macos: :high_sierra # needs futimens

  def install
    ENV.cxx11

    args = %W[
      --prefix=#{prefix}
      --disable-dependency-tracking
      --disable-sdltest
    ]
    system "./build-macosx", *args
    system "make", "install"
  end

  test do
    assert_match "DOSBox-X version #{version}", shell_output("#{bin}/dosbox-x -version 2>&1", 1)
  end
end
